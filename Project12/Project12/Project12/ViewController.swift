//
//  ViewController.swift
//  Project12
//
//  Created by Ian McDonald on 19/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {

    @IBOutlet weak var receivedData: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let complication = UIBarButtonItem(title: "Complication", style: .plain,
                                           target: self,
                                           action: #selector(sendComplicationTapped))
        let message = UIBarButtonItem(title: "Message", style: .plain,
                                      target: self,
                                      action: #selector(sendMessageTapped))
        let appInfo = UIBarButtonItem(title: "Context", style: .plain,
                                      target: self,
                                      action: #selector(sendAppContextTaped))
        let file = UIBarButtonItem(title: "File", style: .plain,
                                   target: self,
                                   action: #selector(sendFileTapped))
        navigationItem.leftBarButtonItems = [complication, message, appInfo, file]
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    @objc func sendMessageTapped() {
        let session = WCSession.default
        
        /*if session.activationState == .activated {
            let data = ["text": "User info from the phone"]
            session.transferUserInfo(data)
        }*/
        
        if session.isReachable {
            let data = ["text" : "A message from the phone"]
            session.sendMessage(data, replyHandler: { response in
                DispatchQueue.main.async {
                    self.receivedData.text = "Received response: \(response)"
                }
            })
        }
        
    }
    
    @objc func sendAppContextTaped() {
        let session = WCSession.default
        
        if session.activationState == .activated {
            let data = ["text" : "Hello from the phone"]
            
            do {
                try session.updateApplicationContext(data)
            } catch {
                print("Alert! Updating app context failed")
            }
        }
    }
    
    @objc func sendComplicationTapped() {
        let session = WCSession.default
        
        // check that we are good to send
        if session.activationState == .activated && session.isComplicationEnabled {
            // pick a random number and wrap it in a dictionary
            let randomNumber = String(Int.random(in: 0...9))
            let message = ["number" : randomNumber]
            
            // transfer it across using a high-priority send
            session.transferCurrentComplicationUserInfo(message)
            
            // output how many high-priority sends we have left
            print("Attempted to send complication data. Remaining transfers: \(session.remainingComplicationUserInfoTransfers)")
        }
    }
    
    @objc func sendFileTapped() {
        let session = WCSession.default
        
        if session.activationState == .activated {
            // create a URL for where the file is/will be saved
            let fm = FileManager.default
            let sourceURL = getDocumentsDirectory().appendingPathComponent("saved_file")
            
            if !fm.fileExists(atPath: sourceURL.path) {
                // the file doesn't exist - create it now
                try? "Hello, from a phone file!".write(to: sourceURL, atomically: true,
                                                       encoding: String.Encoding.utf8)
            }
            
            // the file exists now; send it across the session
            session.transferFile(sourceURL, metadata: nil)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        DispatchQueue.main.async {
            if activationState == .activated {
                if session.isWatchAppInstalled {
                    self.receivedData.text = "Watch app is installed!"
                }
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        DispatchQueue.main.async {
            if let text = userInfo["text"] as? String {
                self.receivedData.text = text
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async {
            if let text = message["text"] as? String {
                self.receivedData.text = text
            }
        }
    }

}

