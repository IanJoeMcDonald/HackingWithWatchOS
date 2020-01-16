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
    @IBOutlet weak var rock: WKInterfaceButton!
    @IBOutlet weak var paper: WKInterfaceButton!
    @IBOutlet weak var scissors: WKInterfaceButton!
    
    @IBOutlet weak var levelCounter: WKInterfaceLabel!
    @IBOutlet weak var timer: WKInterfaceTimer!
    
    @IBOutlet weak var result: WKInterfaceLabel!
    
    var allMoves = ["rock", "paper", "scissors"]
    var shouldWin = true
    var level = 1
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        rock.setBackgroundImage(UIImage(named: "rock"))
        paper.setBackgroundImage(UIImage(named: "paper"))
        scissors.setBackgroundImage(UIImage(named: "scissors"))
        
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
        
        allMoves.shuffle()
        question.setImage(UIImage(named: allMoves[0]))
    }

    func check(for answer: String) {
        if allMoves[0] == answer {
            level += 1
            newLevel()
        } else {
            level -= 1
            if level < 1 { level = 1 }
            newLevel()
        }
    }
    
    @IBAction func rockTapped() {
        if shouldWin {
            check(for: "scissors")
        } else {
            check(for: "paper")
        }
    }
    @IBAction func paperTapped() {
        if shouldWin {
            check(for: "rock")
        } else {
            check(for: "scissors")
        }
    }
    @IBAction func scissorsTapped() {
        if shouldWin {
            check(for: "paper")
        } else {
            check(for: "rock")
        }
    }
}
