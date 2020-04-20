//
//  InterfaceController.swift
//  Project12 WatchKit Extension
//
//  Created by Ian McDonald on 19/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet weak var receivedData: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
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

    @IBAction func sendDataTapped() {
        let session = WCSession.default
        
        /*if session.activationState == .activated {
            let data = ["text":"Hello from the watch"]
            session.transferUserInfo(data)
        }*/
        
        if session.isReachable {
            let data = ["text" : "Hello from the watch"]
            session.sendMessage(data, replyHandler: nil)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            if let text = userInfo["text"] as? String {
                self.receivedData.setText(text)
            } else if let number = userInfo["number"] as? String {
                UserDefaults.standard.set(number, forKey: "complication_number")
                
                let server = CLKComplicationServer.sharedInstance()
                guard let complications = server.activeComplications else { return }
                for complication in complications {
                    server.reloadTimeline(for: complication)
                }
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let text = message["text"] as? String {
                self.receivedData.setText(text)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        DispatchQueue.main.async {
            if let text = message["text"] as? String {
                // use our message data locally
                self.receivedData.setText(text)
                
                // send back out reply
                replyHandler(["response": "Be excellent to each other"])
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("Application state received")
        print(applicationContext)
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("File received!")
        
        // create a URL representing where to save the file
        let fm = FileManager.default
        let destURL = getDocumentsDirectory().appendingPathComponent("saved_file")
        
        do {
            if fm.fileExists(atPath: destURL.path) {
                // the file already exists - delete it
                try fm.removeItem(at: destURL)
            }
            
            // copy the file from its temporary location
            try fm.copyItem(at: file.fileURL, to: destURL)
            
            // load the file and print it out
            let contents = try String(contentsOf: destURL)
            print(contents)
        } catch {
            // something went wrong!
            print("File copy failed")
            
        }
    }
}
