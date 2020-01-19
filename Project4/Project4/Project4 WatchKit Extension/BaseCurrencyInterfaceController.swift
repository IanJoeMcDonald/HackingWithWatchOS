//
//  BaseCurrencyInterfaceController.swift
//  Project4 WatchKit Extension
//
//  Created by Ian McDonald on 18/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation


class BaseCurrencyInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    let selectedColor = UIColor(red: 0, green: 0.55, blue: 0.25, alpha: 1)
    let deselectedColor = UIColor(red: 0.3, green: 0, blue: 0, alpha: 1)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(InterfaceController.currencies.count, withRowType: "Row")
        
        let defaults =  UserDefaults.standard
        let selectedCurrency = defaults.string(forKey: InterfaceController.conversionCurrencyKey) ?? "USD"
        
        let selectedIndex = InterfaceController.currencies.firstIndex(of: selectedCurrency)
        
        for (index, currency) in InterfaceController.currencies.enumerated() {
            guard let row = table.rowController(at: index) as? CurrencyRow else { continue }
            row.textLabel.setText(currency)
            row.group.setBackgroundColor(deselectedColor)
            
            if index == selectedIndex {
                row.group.setBackgroundColor(selectedColor)
            }
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
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        for index in 0 ..< table.numberOfRows {
            guard let row = table.rowController(at: index) as? CurrencyRow else { return }
            if index == rowIndex {
                row.group.setBackgroundColor(selectedColor)
            } else {
                row.group.setBackgroundColor(deselectedColor)
            }
        }
        
        UserDefaults.standard.set(InterfaceController.currencies[rowIndex], forKey: InterfaceController.conversionCurrencyKey)
    }
}
