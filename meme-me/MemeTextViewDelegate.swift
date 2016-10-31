//
//  MemeTextViewDelegate.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 13.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class MemeTextViewDelegate : NSObject, UITextViewDelegate {
    
    //
    // MARK : Delegate TextView Controls
    //
    
    // force vertical alignment (re)calculation on any text change made
    func textViewDidChange(
        _ textView: UITextView) {
        
        let memeTextView = textView as! MemeTextView
        
        memeTextView.verticalAlign(position: memeTextView.verticalAlignment)
    }
    
    // dismiss keyboard on pressing "done" or "return" so far and forcefully uppercas any user input
    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {
        
        let memeTextView = textView as! MemeTextView
        let memeTextCurrent = memeTextView.text
        
        if text == "\n" {
            
            memeTextView.resignFirstResponder()
            
            return false
        }
        
        memeTextView.text = (memeTextCurrent! as NSString).replacingCharacters(in: range, with: text.uppercased())
        
        return false
    }
    
    // clear textView on clicking default text placeholder, leave text as is on existing (not default) content
    @objc(textViewDidBeginEditing:) func textViewDidBeginEditing(
        _ textView: UITextView) {
        
        let memeTextView = textView as! MemeTextView
        if (memeTextView.hasDefaultText()) {
            memeTextView.text = ""
        }
        
        textView.verticalAlign(position: memeTextView.verticalAlignment)
    }
}
