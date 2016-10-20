//
//  MemeTableViewControllerExtensions.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 20.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

extension MemeTableViewController {
    
    func initTableView() {
    
        if !isDataAvailable() {
            
            noDataImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataImageView.contentMode = .scaleAspectFit
            noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataPortrait")
            
            tableView.backgroundView = noDataImageView
            tableView.separatorStyle = .none
            
        } else {
            
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
    }
    
    func isDataAvailable() -> Bool {
        return memes.count > 0
    }
}
