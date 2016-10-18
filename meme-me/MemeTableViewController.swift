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
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    //
    // MARK: TableViewController Overrides, LifeCycle Methods
    //
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableView.layoutSubviews()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        print ("------------------------------------------")
        for meme in memes {
            print("memeTextTop: '\(meme.textTop!)'")
            print("memeTextBottom: '\(meme.textBottom!)'")
            print("-- next --")
        }
        print ("------------------------------------------")
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print ("bar")
        
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
         
         let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMemeCell") as! MemeTableViewCell
         cell.memeImage.image = meme.imageOrigin!
         cell.memeLabelTop.text = meme.textTop!
         cell.memeLabelTop.text = meme.textBottom!
        
         */
        
        print ("foo")
        
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomMemeCell")! as UITableViewCell
        
        cell.imageView?.image = meme.imageOrigin!
        cell.textLabel?.text = meme.textTop!
        
        return cell
    }
}
