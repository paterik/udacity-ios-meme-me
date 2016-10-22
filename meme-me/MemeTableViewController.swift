//
//  MemeTableViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 18.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit
import BGTableViewRowActionWithImage

class MemeTableViewController: UITableViewController {
    
    let memeCellHeight: CGFloat = 80.0
    let memeCellImageCornerRadius: CGFloat = 5
    let memeCellIdent = "CustomMemeCell"
    
    var noDataImageView : UIImageView!
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    var appDelegate: AppDelegate { return (UIApplication.shared.delegate as! AppDelegate) }
    
    //
    // MARK: TableViewController Overrides, LifeCycle Methods
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        refreshTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func willRotate(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval) {
        
        if (isDataAvailable()) {
            return
        }
        
        noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataPortrait")
        if (toInterfaceOrientation.isLandscape) {
            noDataImageView.image = UIImage(imageLiteralResourceName: "WelcomeNoDataLandscape")
        }
    }

    override func tableView(
        _ tableView: UITableView,
          numberOfRowsInSection section: Int) -> Int {

        refreshTableView()
        
        return appDelegate.memes.count
    }
    
    override func tableView(
        _ tableView: UITableView,
          heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return memeCellHeight;
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // definition for my editButton using 3rd party lib BGTableViewRowActionWithImage
        let edit = BGTableViewRowActionWithImage.rowAction(
            with: UITableViewRowActionStyle.default,
            title: " Edit ",
            
            backgroundColor: UIColor(netHex: 0x174881),
            image: UIImage(named: "Edit_v2"),
            forCellHeight: 98) { action, index in
                
                print("edit button tapped")
        }
        
        // definition for my deleteButton also using 3rd party lib BGTableViewRowActionWithImage
        let delete = BGTableViewRowActionWithImage.rowAction(
            with: UITableViewRowActionStyle.destructive,
            title: "Delete",
            
            backgroundColor: UIColor(netHex: 0xD30038),
            image: UIImage(named: "Delete_v2"),
            forCellHeight: 98) { action, index in
                
                print("delete button tapped")
                self.appDelegate.removeMeme(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete!, edit!]
    }

    
    override func tableView(
        _ tableView: UITableView,
          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: memeCellIdent) as! MemeTableViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        cell.memeLabelTop.text = meme.textTop!
        cell.memeLabelBottom.text = meme.textBottom!
        cell.memeImage.layer.cornerRadius = memeCellImageCornerRadius
        cell.memeTagImage?.image = nil
        
        if meme.fresh! == true {
            cell.memeTagImage?.image = UIImage(named:"NewMeme")!
        }
        
        return cell
    }
}
