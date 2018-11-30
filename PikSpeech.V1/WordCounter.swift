//
//  WordCounter.swift
//  PikSpeech.V1
//
//  Created by Miguel Taningco on 2018-11-29.
//  Copyright © 2018 cmpt275group11. All rights reserved.
//

import Foundation

class WordCounter{
    private var word : String
    private var count : Int
    
    init(word: String, count : Int) {
        self.word = word
        self.count = count
    }
    
    func getWord() -> String{
        return word
    }
    
    func getCount() -> Int{
        return count
    }
}
