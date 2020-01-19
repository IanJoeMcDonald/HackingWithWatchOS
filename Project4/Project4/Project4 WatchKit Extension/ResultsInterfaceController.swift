//
//  ResultsInterfaceController.swift
//  Project4 WatchKit Extension
//
//  Created by Ian McDonald on 18/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation


class ResultsInterfaceController: WKInterfaceController {
    @IBOutlet weak var table: WKInterfaceTable!
    @IBOutlet weak var status: WKInterfaceLabel!
    @IBOutlet weak var done: WKInterfaceButton!
    
    var fetchedCurrencies = [(symbol: String, rate: Double)]()
    var amountToConvert = 0.0
    let appID = "a7218257dc394913bb0ec9a6f710d83f"
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        guard let settings = context as? [String: String] else { return }
        guard let amount = settings["amount"] else { return }
        guard let baseCurrency = settings["base"] else { return }
        
        amountToConvert = Double(amount) ?? 50
        setTitle("\(amount) \(baseCurrency)")
        DispatchQueue.global(qos: .userInteractive).async {
            self.fetchDate(for: baseCurrency)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WKExtension.shared().isAutorotating = true
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        WKExtension.shared().isAutorotating = false
    }

    func fetchDate(for baseCurrency: String) {
        if let url = URL(string: "https://openexchangerates.org/api/latest.json?app_id=\(appID)&base=\(baseCurrency)") {
            let urlRequest = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: urlRequest) {
                data, response, error in
                if let data = data {
                    self.parse(data)
                } else {
                    DispatchQueue.main.async {
                        self.status.setText("Fetch failed")
                        self.done.setHidden(false)
                    }
                }
            }.resume()
        }
    }
    
    func parse(_ contents: Data) {
        let decoder = JSONDecoder()
        
        guard let result = try? decoder.decode(CurrencyResult.self, from: contents) else {
            DispatchQueue.main.async {
                self.status.setText("Fetch failed")
                self.done.setHidden(false)
            }
            return
        }
        
        let defaults = UserDefaults.standard
        let selectedCurrencies = defaults.array(forKey: InterfaceController.selectedCurrenciesKey) as? [String] ?? InterfaceController.defaultCurrencies
        
        for symbol in result.rates {
            guard selectedCurrencies.contains(symbol.key) else { continue }
            let rateName = symbol.key
            let rateValue = symbol.value
            fetchedCurrencies.append((symbol: rateName, rate: rateValue))
        }
        
        updateTable()
        status.setHidden(true)
        table.setHidden(false)
        done.setHidden(false)
    }
    
    func updateTable() {
        table.setNumberOfRows(fetchedCurrencies.count, withRowType: "Row")
        
        for(index, currency) in fetchedCurrencies.enumerated() {
            guard let row = table.rowController(at: index) as? CurrencyRow else { return }
            let value = currency.rate * amountToConvert
            let formattedValue = String(format: "%.2f", value)
            row.textLabel.setText("\(formattedValue) \(currency.symbol)")
        }
        
    }
    
    @IBAction func doneTapped() {
        WKInterfaceController.reloadRootPageControllers(withNames: ["Home", "Currencies"],
                                                        contexts: nil, orientation: .horizontal,
                                                        pageIndex: 0)
    }
}
