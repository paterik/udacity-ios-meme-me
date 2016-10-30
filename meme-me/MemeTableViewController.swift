//
//  MemeTableViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 18.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit
import BGTableViewRowActionWithImage

class MemeTableViewController: UITableViewController {
    
    // constants
    let memeCellHeight: CGFloat = 80.0
    let memeCellHeightSwipeActions: UInt = 98
    let memeCellImageCornerRadius: CGFloat = 5
    let memeCellIdent = "CustomMemeCell"
    let memeIconNew = "IconNew"
    let memeIconUdpdated = "IconUpdated"
    
    // variables
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
    
    override func tableView(
        _ tableView: UITableView,
          canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(
        _ tableView: UITableView,
          editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // definition for my editButton using 3rd party lib BGTableViewRowActionWithImage
        let edit = BGTableViewRowActionWithImage.rowAction(
            with: UITableViewRowActionStyle.default,
            title: " Edit ",
            
            backgroundColor: UIColor(netHex: 0x174881),
            image: UIImage(named: "Edit_v2"),
            forCellHeight: memeCellHeightSwipeActions) { action, index in
                
                let editViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeEditViewController") as! MemeEditViewController
                editViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                editViewController.editMode = true
                editViewController.currentMeme = self.memes[indexPath.row]
                editViewController.currentMemeRowIndex = indexPath.row
                
                self.present(editViewController, animated: true, completion: nil)
        }
        
        // definition for my deleteButton also using 3rd party lib BGTableViewRowActionWithImage
        let delete = BGTableViewRowActionWithImage.rowAction(
            with: UITableViewRowActionStyle.destructive,
            title: "Delete",
            
            backgroundColor: UIColor(netHex: 0xD30038),
            image: UIImage(named: "Delete_v2"),
            forCellHeight: memeCellHeightSwipeActions) { action, index in
                
                self.appDelegate.removeMeme(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        return [delete!, edit!]
    }
    
    override func tableView(
        _ tableView: UITableView,
          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let meme = memes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: memeCellIdent, for: indexPath) as! MemeTableViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        cell.memeLabelTop.text = meme.textTop!
        cell.memeLabelBottom.text = meme.textBottom!
        cell.memeImage.layer.cornerRadius = memeCellImageCornerRadius
        cell.memeTagImage?.image = nil
        
        // tag meme if newly generated
        if meme.fresh! == true {
            cell.memeTagImage?.image = UIImage(named: memeIconNew)!
        }
        
        // tag meme if updated recently
        if meme.updated! == true {
            cell.memeTagImage?.image = UIImage(named: memeIconUdpdated)!
        }
        
        return cell
    }
    
    override func tableView(
        _ tableView: UITableView,
          didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let transition = CATransition()
        
        detailViewController.currentMeme = memes[indexPath.row]

        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(detailViewController, animated: false, completion: nil)
    }
}
