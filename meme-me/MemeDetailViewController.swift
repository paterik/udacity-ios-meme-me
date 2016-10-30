//
//  MemeDetailViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 22.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
   
    //
    // MARK: CollectionViewController IBOutlets
    //
    
    @IBOutlet weak var memeDetailView: UIImageView!
    
    var currentMeme: Meme?

    //
    // MARK: TableViewController Overrides, LifeCycle Methods
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        prepareDetailView()
    }
    
    //
    // MARK: CollectionViewController @IBActions
    //
    
    @IBAction func exitMemeDetailView(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    //
    // set orientation to portrati (fix) in detailView
    //
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    //
    // disable orientation switch in detailView
    //
    override var shouldAutorotate: Bool {
        
        return false
    }
}
