//
//  MemeCollectionViewControllerExtension.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 20.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

extension MemeCollectionViewController {

    func layoutCellLabels(labels: [UILabel]) {
        
        for label in labels {
            
            let memeTextAttributes = [
                NSStrokeColorAttributeName : UIColor.black,
                NSForegroundColorAttributeName : UIColor.white,
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 14.0)!,
                NSStrokeWidthAttributeName : -2
                ] as [String : Any]
            
            label.attributedText = NSMutableAttributedString(string: label.text! as String, attributes:memeTextAttributes)
            label.adjustsFontSizeToFitWidth = true
            label.textAlignment = .center
        }
    }
    
    func refreshCollectionView() {
        
        if isDataAvailable() {
            collectionView?.reloadData()
        }
    }
    
    func isDataAvailable() -> Bool {
        
        return memes.count > 0
    }
}
