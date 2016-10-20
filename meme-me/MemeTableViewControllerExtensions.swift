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
    
    func getNoDataImageView() -> UIImageView {
    
        noDataImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataImageView.contentMode = .scaleAspectFit
        noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataPortrait")
        if UIDevice.current.orientation.isLandscape {
            noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataLandscape")
        }
        
        return noDataImageView
    }
    
    func refreshTableView() {
    
        if !isDataAvailable() {
            tabBarController?.tabBar.isHidden = true
            tableView.backgroundView = getNoDataImageView()
            tableView.separatorStyle = .none
            
        } else {
            tabBarController?.tabBar.isHidden = false
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
        }
    }
    
    func isDataAvailable() -> Bool {
        
        return memes.count > 0
    }
}
