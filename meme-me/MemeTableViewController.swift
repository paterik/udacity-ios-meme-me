//
//  MemeTableViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 18.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UITableViewController {
    
    let memeCellHeight: CGFloat = 72.0
    let memeCellIdent = "CustomMemeCell"
    
    var noDataImageView: UIImageView!
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    
    //
    // MARK: TableViewController Overrides, LifeCycle Methods
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initTableView()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        if (isDataAvailable()) {
            return
        }
        
        noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataPortrait")
        if (toInterfaceOrientation.isLandscape) {
            noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataLandscape")
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return memeCellHeight;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: memeCellIdent) as! MemeTableViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        cell.memeLabelTop.text = meme.textTop!
        cell.memeLabelBottom.text = meme.textBottom!
        
        return cell
    }
}
