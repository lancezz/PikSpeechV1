//
//  DataPoint.swift
//  PikSpeech.V1
//
//  Created by Miguel Taningco on 2018-11-29.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import Foundation


class DataPoint{
    private var date : NSDate
    private var frequency : Int
    
    init(date: NSDate, frequency: Int) {
        self.date = date
        self.frequency = frequency
    }
    
    func getDate() -> NSDate{
        return date
    }
    
    func getFrequency() -> Int{
        return frequency
    }
}
