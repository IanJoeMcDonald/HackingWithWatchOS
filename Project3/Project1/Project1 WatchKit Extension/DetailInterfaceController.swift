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

    @IBOutlet weak var textLabel: WKInterfaceLabel!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let contextDictionary = context as? [String : String] {
            textLabel.setText(contextDictionary["note"] ?? "")
            
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

}
