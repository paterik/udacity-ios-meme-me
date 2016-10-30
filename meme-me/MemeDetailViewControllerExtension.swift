//
//  MemeDetailViewControllerExtension.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 22.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

extension MemeDetailViewController {

    //
    // MARK: UI/Control Methods
    //
    
    func prepareDetailView() {
    
        memeDetailView.image = currentMeme!.image
    }
}
