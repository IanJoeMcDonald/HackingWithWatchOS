//
//  InterfaceController.swift
//  Project10 WatchKit Extension
//
//  Created by Ian McDonald on 12/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var table: WKInterfaceTable!
    let activities: [(String, HKWorkoutActivityType)] = [("Cycling", .cycling),
                                                         ("Running", .running),
                                                         ("Swimming", .swimming),
                                                         ("Wheelchair", .wheelchairRunPace)]
    var selectedActivity = HKWorkoutActivityType.cycling
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(activities.count, withRowType: "Row")
        for rowIndex in 0 ..< activities.count {
            set(row: rowIndex, to: activities[rowIndex].0)
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

    func set(row rowIndex: Int, to text: String) {
        guard let row = table.rowController(at: rowIndex) as? ActivitySelectRow else { return }
        row.textLabel.setText(text)
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        selectedActivity = activities[rowIndex].1
        guard HKHealthStore.isHealthDataAvailable() else { return }
        WKInterfaceController.reloadRootPageControllers(withNames: ["WorkoutInterfaceController"],
                                                        contexts: [selectedActivity],
                                                        orientation: .horizontal,
                                                        pageIndex: 0)
    }
}
