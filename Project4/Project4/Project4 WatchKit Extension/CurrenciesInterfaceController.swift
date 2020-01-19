//
//  CurrenciesInterfaceController.swift
//  Project4 WatchKit Extension
//
//  Created by Ian McDonald on 18/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation


class CurrenciesInterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    
    let selectedColor = UIColor(red: 0, green: 0.55, blue: 0.25, alpha: 1)
    let deselectedColor = UIColor(red: 0.3, green: 0, blue: 0, alpha: 1)
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(InterfaceController.currencies.count, withRowType: "Row")
        
        let defaults =  UserDefaults.standard
        let selectedCurrencies = defaults.array(forKey: InterfaceController.selectedCurrenciesKey) as? [String] ?? InterfaceController.defaultCurrencies
        
        for (index, currency) in InterfaceController.currencies.enumerated() {
            guard let row = table.rowController(at: index) as? CurrencyRow else { continue }
            row.textLabel.setText(currency)
            
            if selectedCurrencies.contains(currency) {
                row.group.setBackgroundColor(selectedColor)
            } else {
                row.group.setBackgroundColor(deselectedColor)
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
        guard let row = table.rowController(at: rowIndex) as? CurrencyRow else { return }
        
        let defaults = UserDefaults.standard
        var selectedCurrencies = defaults.array(forKey: InterfaceController.selectedCurrenciesKey) as? [String] ?? InterfaceController.defaultCurrencies
        
        let selectedCurrency = InterfaceController.currencies[rowIndex]
        
        if let index = selectedCurrencies.firstIndex(of: selectedCurrency) {
            selectedCurrencies.remove(at: index)
            row.group.setBackgroundColor(deselectedColor)
        } else {
            selectedCurrencies.append(selectedCurrency)
            row.group.setBackgroundColor(selectedColor)
        }
        
        defaults.set(selectedCurrencies, forKey: InterfaceController.selectedCurrenciesKey)
    }

}
