//
//  DetailInterfaceController.swift
//  Project1 WatchKit Extension
//
//  Created by Ian McDonald on 06/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation


class DetailInterfaceController: WKInterfaceController {
    
    var labelText = ""

    @IBOutlet weak var textLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let contextDictionary = context as? [String : String] {
            showTextNote(contextDictionary)
        }
    }
    
    func playAudioNote(_ name: String) {
        let saveURL = InterfaceController.getDocumentsDirectory().appendingPathComponent(name)
        if FileManager.default.fileExists(atPath: saveURL.path) {
            let options = [WKMediaPlayerControllerOptionsAutoplayKey: "true"]
            
            presentMediaPlayerController(with: saveURL, options: options) { didPlayToEnd, endTime, error in
                // do nothing here
            }
        }
    }
    
    func showTextNote(_ dictionary: [String:String]) {
        labelText = dictionary["note"] ?? ""
        textLabel.setText(labelText)
        
        let index = dictionary["index"] ?? "1"
        let totalNumber = dictionary["totalNumber"] ?? "1"
        setTitle("Note \(index) / \(totalNumber)")
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if labelText.hasPrefix("Audio Note:") {
            playAudioNote(labelText)
        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
