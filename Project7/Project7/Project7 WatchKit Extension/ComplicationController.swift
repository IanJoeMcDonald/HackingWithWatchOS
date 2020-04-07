//
//  ComplicationController.swift
//  Project7 WatchKit Extension
//
//  Created by Masipack Eletronica on 07/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import ClockKit


class ComplicationController: NSObject, CLKComplicationDataSource {
    
    let positiveAnswers: Set<String> = ["It is certain", "It is decidedly so", "Without a doubt",
                                        "Yes definitely", "As i see it, yes", "Most likely",
                                        "Outlook good", "Yes", "Signs point to yes"]
    let uncertainAnswers: Set<String> = ["Reply hazy, try again", "Ask again later",
                                         "Better not teel you now", "Cannot predict now",
                                         "Concentrate and ask again"]
    let negativeAnswers: Set<String> = ["Don't count on it", "My reply is no", "My sources say no",
                                        "Outlook not so good", "Very doublful"]
    var allAnswers = [String]()
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let startDate = Date().addingTimeInterval(-86400)
        handler(startDate)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        let endDate = Date().addingTimeInterval(86400)
        handler(endDate)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        allAnswers = Array(positiveAnswers) + Array(uncertainAnswers) + Array(negativeAnswers)
        
        getTimelineEntries(for: complication, before: Date(), limit: 1) {
            handler($0?.first)
        }
    }
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        var entries = [CLKComplicationTimelineEntry]()
        
        // note: reverse loop!
        for i in (0 ..< limit).reversed() {
            let predictionDate = date.addingTimeInterval(Double(-60 * 5 * i))
            let predictionTemplate = template(for: complication.family, date: predictionDate)
            let entry = CLKComplicationTimelineEntry(date: predictionDate, complicationTemplate: predictionTemplate)
            entries.append(entry)
        }
        
        handler(entries)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // 1: Create an empty array to return
        var entries = [CLKComplicationTimelineEntry]()
        
        // 2: Create as many entries as requested
        for i in 0 ..< limit {
            // 3: Calculate the date for this result
            let predictionDate = date.addingTimeInterval(Double(60 * 5 * i))
            
            // 4: Fetch a completed template for this date
            let predictionTemplate = template(for: complication.family, date: predictionDate)
            
            // 5: Add in the date
            let entry = CLKComplicationTimelineEntry(date: predictionDate, complicationTemplate: predictionTemplate)
            
            // 6: Append to our result array
            entries.append(entry)
        }
        
        // 7: Send back the timeline
        handler(entries)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        switch complication.family {
        case .modularLarge:
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Magic 8-Ball",
                                                                shortText: "8-Ball")
            template.body1TextProvider = CLKSimpleTextProvider(text: "Your Prediction",
                                                               shortText: "Prediction")
            handler(template)
        case .modularSmall:
            let template = CLKComplicationTemplateModularSmallSimpleText()
            template.textProvider = CLKSimpleTextProvider(text: "8")
            handler(template)
        default:
            handler(nil)
        }
    }
    
    func template(for family: CLKComplicationFamily, date: Date) -> CLKComplicationTemplate {
        // find the correct prediction for this date
        let predictionNumber = Int(date.timeIntervalSince1970) % allAnswers.count
        let prediction = allAnswers[predictionNumber]
        
        switch family {
        case .modularLarge:
            // create a long, text-based prediction
            let template = CLKComplicationTemplateModularLargeStandardBody()
            template.headerTextProvider = CLKSimpleTextProvider(text: "Magic 8-ball")
            template.body1TextProvider = CLKSimpleTextProvider(text: prediction)
            return template
        default:
            // create a short, emoji-based prediction
            let template = CLKComplicationTemplateModularSmallSimpleText()
            if positiveAnswers.contains(prediction) {
                template.textProvider = CLKSimpleTextProvider(text: "😀")
            } else if uncertainAnswers.contains(prediction) {
                template.textProvider = CLKSimpleTextProvider(text: "🤔")
            } else {
                template.textProvider = CLKSimpleTextProvider(text: "😮")
            }
            
            return template
        }
        
    }
    
}
