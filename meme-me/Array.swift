//
//  Array.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 22.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation

extension Array {
    
    // randomizing order of array elements
    mutating func shuffle()
    {
        let shuffleIterations = 10
        for _ in 0..<shuffleIterations
        {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
