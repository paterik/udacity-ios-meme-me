//
//  MemeTextViewDelegate.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 13.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

class MemeTextViewDelegate : NSObject, UITextViewDelegate {
    
    func textViewDidChange(
        _ textView: UITextView) {
        
        let memeTextView = textView as! MemeTextView
        
        memeTextView.verticalAlign(position: memeTextView.verticalAlignment)
    }
    
    @objc(textViewDidBeginEditing:) func textViewDidBeginEditing(
        _ textView: UITextView) {
        
        let memeTextView = textView as! MemeTextView
        if (memeTextView.hasDefaultText()) {
            memeTextView.text = ""
        }
        
        textView.verticalAlign(position: memeTextView.verticalAlignment)
    }
}
