//
//  UITextView.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 28.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

extension UITextView {
    
    // enable vertical alignment repositioning of textView content
    func verticalAlign(position: String = "top") {
        
        let textView = self
        let height = textView.bounds.size.height
        let contentHeight:CGFloat = contentSize.height
        
        var topCorrect: CGFloat = 0.0
        
        switch(position) {
            case "top":
                textView.contentOffset = CGPoint.zero
            case "middle":
                topCorrect = (height - contentHeight * textView.zoomScale)/2.0
                topCorrect = topCorrect < 0 ? 0 : topCorrect
                textView.contentOffset = CGPoint(x: 0, y: -topCorrect)
            case "bottom":
                topCorrect = textView.bounds.size.height - contentHeight
                topCorrect = topCorrect < 0 ? 0 : topCorrect
                textView.contentOffset = CGPoint(x: 0, y: -topCorrect)
        
            default:
                textView.contentOffset = CGPoint.zero
        }
        
        if contentHeight >= height {
            topCorrect = contentHeight - height
            topCorrect = topCorrect < 0 ? 0 : topCorrect
            textView.contentOffset = CGPoint(x: 0, y: topCorrect)
        }
    
        textView.isScrollEnabled = true
    }
}
