//
//  InterfaceController.swift
//  Project5 WatchKit Extension
//
//  Created by Ian McDonald on 27/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation
import UserNotifications


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var tlButton: WKInterfaceButton!
    @IBOutlet weak var trButton: WKInterfaceButton!
    @IBOutlet weak var blButton: WKInterfaceButton!
    @IBOutlet weak var brButton: WKInterfaceButton!
    
    var buttons = [WKInterfaceButton]()
    var startTime = Date()
    
    var colors = [
        "Red": UIColor.red,
        "Green": UIColor(red: 0, green: 0.5, blue: 0, alpha: 1),
        "Blue": UIColor.blue,
        "Orange": UIColor.orange,
        "Purple": UIColor.purple,
        "Black": UIColor.black,
    ]
    
    var colorBlind = [
        "Heart": "♥️",
        "Spade": "♠️",
        "Diamond": "♦️",
        "Club": "♣️",
        "Triangle": "🔺"
    ]
    
    var currentLevel = 0
    var colorBlindMode = false
   
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        buttons += [tlButton, trButton, blButton, brButton]
        startNewGame()
        setPlayReminder()
    }
   
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func levelUp() {
        currentLevel += 1
        
        if colorBlindMode {
            setColorBlindButtons()
        } else {
            setButtonColors()
        }
        
        if currentLevel == 10 {
            let playAgain = WKAlertAction(title: "Play Again", style: .default) {
                self.startNewGame()
            }
            
            let timePassed = Date().timeIntervalSince(startTime)
            
            presentAlert(withTitle: "You win!",
                         message: "You finished in \(Int(timePassed)) seconds",
                         preferredStyle: .alert,
                         actions: [playAgain])
            
            return
        }
    }
    
    func setButtonColors() {
        // pull out the color names and shuffle them with the buttons
        var colorKeys = Array(colors.keys)
        colorKeys.shuffle()
        buttons.shuffle()
        
        // loop over all the buttons
        for (index, button) in buttons.enumerated() {
            // give them a color from the `colors` dictionaru
            button.setBackgroundColor(colors[colorKeys[index]])
            
            // make sure they are enabled
            button.setEnabled(true)
            if index == 0 {
                // this should have the wrong title
                button.setTitle(colorKeys[colorKeys.count - 1])
            } else {
                // this should have the correct title
                button.setTitle(colorKeys[index])
            }
        }
    }
    
    func setColorBlindButtons() {
        var colorBlindKeys = Array(colorBlind.keys)
        colorBlindKeys.shuffle()
        buttons.shuffle()
        
        for (index, button) in buttons.enumerated() {
            // set color to white for more contrast
            button.setBackgroundColor(UIColor.white)
            button.setEnabled(true)
            
            // get the image to be shown on the top of the button
            var text = colorBlind[colorBlindKeys[index]] ?? ""
            text += "\n"
            if index == 0 {
                // this should have the wrong title
                text +=  colorBlindKeys[colorBlindKeys.count - 1]
            } else {
                // this should have the correct title
                text += colorBlindKeys[index]
            }
            
            // create attributed string to set color to Black
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.setAttributes([NSAttributedString.Key.foregroundColor: UIColor.black],
                                           range: NSMakeRange(0, attributedString.length))
            button.setAttributedTitle(attributedString)
        }
    }
    
    @IBAction func startNewGame() {
        startTime = Date()
        currentLevel = 0
        levelUp()
    }
    
    @IBAction func setColorBlindMode() {
        colorBlindMode.toggle()
        startNewGame()
    }
    
    func buttonTapped(_ button: WKInterfaceButton) {
        if button == buttons[0] {
            // correct button!
            levelUp()
        } else {
            // wrong - make them try again
            button.setEnabled(false)
        }
    }
    
    func createNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "We miss you!"
        content.body = "Come back and play the game some more"
        content.categoryIdentifier = "play_reminder"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request)
    }
    
    func setPlayReminder() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (success, error) in
            if success {
                center.removeAllPendingNotificationRequests()
                self.registerCategories()
                self.createNotification()
            }
        }
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        
        let play = UNNotificationAction(identifier: "play", title: "Play Now", options: .foreground)
        let category = UNNotificationCategory(identifier: "play_reminder", actions: [play], intentIdentifiers: [])
        
        center .setNotificationCategories([category])
    }

    @IBAction func tlButtonTapped() {
        buttonTapped(tlButton)
    }
    
    @IBAction func trButtonTapped() {
        buttonTapped(trButton)
    }
    
    @IBAction func blButtonTapped() {
        buttonTapped(blButton)
    }
    
    @IBAction func brButtonTapped() {
        buttonTapped(brButton)
    }
    
}
