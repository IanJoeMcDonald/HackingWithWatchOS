//
//  CurrencyResult.swift
//  Project4 WatchKit Extension
//
//  Created by Ian McDonald on 18/01/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

struct CurrencyResult: Codable {
    var base: String
    var rates: [String: Double]
}
