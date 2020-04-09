//
//  InterfaceController.swift
//  Project2 WatchKit Extension
//
//  Created by Masipack Eletronica on 16/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var question: WKInterfaceImage!
    
    @IBOutlet weak var answers: WKInterfaceGroup!
    @IBOutlet weak var button1: WKInterfaceButton!
    @IBOutlet weak var button2: WKInterfaceButton!
    @IBOutlet weak var button3: WKInterfaceButton!
    
    @IBOutlet weak var levelCounter: WKInterfaceLabel!
    @IBOutlet weak var timer: WKInterfaceTimer!
    
    @IBOutlet weak var result: WKInterfaceLabel!
    
    var allMoves = ["rock", "paper", "scissors"]
    var buttonPositions = [String]()
    var shouldWin = true
    var level = 1
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        timer.start()
        newLevel()
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func newLevel() {
        animate(withDuration: 0.5) {
            self.question.setAlpha(0)
        }
        if level == 21 {
            result.setHidden(false)
            question.setHidden(true)
            answers.setHidden(true)
            timer.stop()
            return
        }
        
        levelCounter.setText("\(level)/20")
        if Bool.random() {
            setTitle("Win!")
            shouldWin = true
        } else {
            setTitle("Lose!")
            shouldWin = false
        }
        
        let oldMove = allMoves[0]
        while oldMove == allMoves[0] {
            allMoves.shuffle()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.question.setImage(UIImage(named: self.allMoves[0]))
            self.animate(withDuration: 0.5) {
                self.question.setAlpha(1)
            }
            self.setButtonImages()
        }
    }

    func check(for answer: String) {
        var correct = false
        if shouldWin {
            if (allMoves[0] == "rock" && answer == "paper") {
                correct = true
            } else if (allMoves[0] == "paper" && answer == "scissors") {
                correct = true
            } else if (allMoves[0] == "scissors" && answer == "rock") {
                correct = true
            } else {
                correct = false
            }
        } else {
            if (allMoves[0] == "rock" && answer == "scissors") {
                correct = true
            } else if (allMoves[0] == "paper" && answer == "rock") {
                correct = true
            } else if (allMoves[0] == "scissors" && answer == "paper") {
                correct = true
            } else {
                correct = false
            }
        }
        
        if correct {
            level += 1
            newLevel()
        } else {
            level -= 1
            if level < 1 { level = 1 }
            newLevel()
        }
    }
    
    func setButtonImages() {
        buttonPositions = allMoves.shuffled()
        button1.setBackgroundImage(UIImage(named: buttonPositions[0]))
        button2.setBackgroundImage(UIImage(named: buttonPositions[1]))
        button3.setBackgroundImage(UIImage(named: buttonPositions[2]))
    }
    
    @IBAction func button1Tapped() {
        check(for: buttonPositions[0])
    }
    @IBAction func button2Tapped() {
        check(for: buttonPositions[1])
    }
    @IBAction func button3Tapped() {
        check(for: buttonPositions[2])
    }
}
