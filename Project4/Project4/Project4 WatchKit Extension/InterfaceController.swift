//
//  InterfaceController.swift
//  Project4 WatchKit Extension
//
//  Created by Ian McDonald on 18/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var amountLabel: WKInterfaceLabel!
    @IBOutlet weak var amountSlider: WKInterfaceSlider!
    
    static let currencies = ["USD", "AUD", "BRL", "CAD", "CHF", "CHY",
                             "EUR","GBP", "HKD", "JPY", "SGD" ]
    static let defaultCurrencies = ["USD", "EUR"]
    static let selectedCurrenciesKey = "SelectedCurrencies"
    let conversionAmountKey = "conversionAmount"
    static let conversionCurrencyKey = "conversionCurrecny"
    var currentAmount = 500
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        currentAmount = UserDefaults.standard.integer(forKey: conversionAmountKey)
        amountLabel.setText(String(currentAmount))
        amountSlider.setValue(Float(currentAmount))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func convertTapped() {
        let currentCurrency = UserDefaults.standard.string(forKey: InterfaceController.conversionCurrencyKey) ?? "USD"
        let context = ["amount": String(currentAmount), "base": currentCurrency]
        
        WKInterfaceController.reloadRootPageControllers(withNames: ["Results"], contexts: [context], orientation: .horizontal, pageIndex: 0)
        
        
    }
    @IBAction func amountChanged(_ value: Float) {
        currentAmount = Int(value)
        amountLabel.setText(String(currentAmount))
        
        UserDefaults.standard.set(currentAmount, forKey: conversionAmountKey)
    }
}
