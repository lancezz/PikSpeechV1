//
//  DailyInformation.swift
//  PikSpeech.V1
//
//  Created by Miguel Taningco on 2018-11-28.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import Foundation

//holds information of the current date and also the top 5 words and its frequency for that day
class DailyInformation{
    private let logDate : NSDate
    private var top5WordsArray = [WordCounter]()
    
    init(logDate : NSDate, top5WordsArray : [WordCounter]) {
        self.logDate = logDate
        self.top5WordsArray = top5WordsArray
    }
    
    func getLogDate() -> NSDate{
        return logDate
    }
    
    func getTop5WordsArray() -> [WordCounter]{
        return top5WordsArray
    }
}
