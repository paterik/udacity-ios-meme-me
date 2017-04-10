//
//  MemeTableViewControllerExtensions.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 20.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

extension MemeTableViewController {
    
    //
    // MARK: controller extension helper functions
    //
    
    func getNoDataImageView() -> UIImageView {
    
        noDataImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataImageView.contentMode = .scaleAspectFit
        noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataPortrait")
        
        if UIDevice.current.orientation.isLandscape {
            noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataLandscape")
        }
        
        return noDataImageView
    }
    
    // ask user for sample meme payload during initial start persist users choice, dont pest customer twice!
    func askForSampleMemes() {
        
        if isDataAvailable() { return }
        
        // Create the subMenu controller (using alertViewController)
        let alertController = UIAlertController(
            title: "Load Sample Memes?",
            message: "You've no memes currently set, do you want to load some sample memes now?",
            preferredStyle: .alert)
        
        let loadFixturesAction = UIAlertAction(title: "Load Sample Memes", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.appDelegate.loadFixtures()
            self.tableView.reloadData()
        }
        
        // Add Basic actions
        alertController.addAction(loadFixturesAction)
        
        // Add Cancel action
        alertController.addAction(UIAlertAction(title: "No Thanks", style: UIAlertActionStyle.cancel) {
            UIAlertAction in return
        })
        
        present(alertController, animated: true, completion: nil)
    }
    
    func refreshTableView() {
    
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
