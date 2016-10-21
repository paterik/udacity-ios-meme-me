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
    
        // todo: check constraints for singleLine !!!
        tableView.separatorStyle = .none
        tabBarController?.tabBar.isHidden = false
        tableView.backgroundView = nil
        
        if !isDataAvailable() {
            tabBarController?.tabBar.isHidden = true
            tableView.backgroundView = getNoDataImageView()
            tableView.separatorStyle = .none
        }
    }
    
    func isDataAvailable() -> Bool {
        
        return appDelegate.memes.count > 0
    }
}
