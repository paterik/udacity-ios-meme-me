//
//  MemeTextView.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 27.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class MemeTextView: UITextView {
    
    var contentDefault: String = ""
    
    func hasDefaultText() -> Bool {
        
        return self.text != contentDefault
    }
}
