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
    
    func textViewShouldReturn(
        _ textView: UITextView) -> Bool {
        
        textView.resignFirstResponder()

        return true
    }
    
    func textView(
        _ textView: UITextView,
          shouldChangeCharactersIn range: NSRange,
          replacementString string: String) -> Bool {
        
        if let text = textView.text {
            
            var topCorrect = (textView.bounds.size.height - (textView.contentSize.height * textView.zoomScale)) / 2
            topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect
            // textView.contentInset.top = -topCorrect
            textView.setContentOffset(CGPoint(x: 0, y: -topCorrect), animated: false)
            
            textView.text = (text as NSString).replacingCharacters(in: range, with: string.uppercased())
        }
        
        return false
    }
    
    @objc(textViewDidBeginEditing:) func textViewDidBeginEditing(
        _ textView: UITextView) {
        
        let memeTextView = textView as! MemeTextView
        if (!memeTextView.hasDefaultText()) {
            memeTextView.text = ""
        }
    }
}
