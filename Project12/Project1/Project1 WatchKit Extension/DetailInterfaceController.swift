//
//  DetailInterfaceController.swift
//  Project1 WatchKit Extension
//
//  Created by Ian McDonald on 06/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class DetailInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet weak var textLabel: WKInterfaceLabel!
    var note: String?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
        // Configure interface objects here.
        if let contextDictionary = context as? [String : String] {
            note = contextDictionary["note"] ?? ""
            textLabel.setText(note)
            
            
            let index = contextDictionary["index"] ?? "1"
            let totalNumber = contextDictionary["totalNumber"] ?? "1"
            setTitle("Note \(index) / \(totalNumber)")
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func sendToPhoneTapped() {
        let session = WCSession.default
        
        if session.isReachable {
            if let note = note {
                let data = ["note" : note]
                session.sendMessage(data, replyHandler: nil)
            }
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
}
