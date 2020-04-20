//
//  ViewController.swift
//  Project6
//
//  Created by Ian McDonald on 29/03/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if activationState == .activated {
            if session.isWatchAppInstalled {
                print("Watch app is installed!")
            }
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("File received!")
        
        // create a URL representing where to save the file
        let fm = FileManager.default
        let destURL = getDocumentsDirectory().appendingPathComponent("recording.wav")
        
        do {
            if fm.fileExists(atPath: destURL.path) {
                // the file already exists - delete it
                try fm.removeItem(at: destURL)
            }
            
            // copy the file from its temporary location
            try fm.copyItem(at: file.fileURL, to: destURL)
        } catch {
            // something went wrong!
            print("File copy failed")
        }
    }
    
}

