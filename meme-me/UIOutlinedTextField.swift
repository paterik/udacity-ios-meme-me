//
//  UIOutlinedTextfield.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 13.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

class UIOutlinedTextField: UITextField {
    
    var outlineWidth: CGFloat = 3
    var outlineColor: UIColor = UIColor.black
    var contentDefault: String = ""
    
    func isChanged() -> Bool {

        return self.text != contentDefault
    }
    
    override func drawText(in rect: CGRect) {
        
        let strokeTextAttributes = [
            NSStrokeColorAttributeName : outlineColor,
            NSStrokeWidthAttributeName : -1 * outlineWidth,
            ] as [String : Any]
        
        self.attributedText = NSAttributedString(string: self.text ?? "", attributes: strokeTextAttributes)
        super.drawText(in: rect)
    }
}

