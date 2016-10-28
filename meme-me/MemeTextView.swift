//
//  MemeTextView.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 27.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class MemeTextView: UITextView {
    
    enum VerticalAlignment: Int {
        case Top = 0, Middle, Bottom
    }
    
    var isTopText: Bool = false
    var isBottomText: Bool = false
    var verticalAlignment: String = "top"
    var contentDefault: String = ""
    
    func hasDefaultText() -> Bool {
        
        return self.text == contentDefault
    }
}
