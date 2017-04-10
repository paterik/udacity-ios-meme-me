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
    // MARK: DetailViewController IBOutlets
    //
    
    @IBOutlet weak var memeDetailView: UIImageView!
    
    //
    // MARK: DetailViewController Internal Variables And Constants
    //
    
    var currentMeme: Meme?

    //
    // MARK: DetailViewController Overrides, LifeCycle Methods
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        prepareDetailView()
    }
    
    //
    // MARK: DetailViewController @IBActions
    //
    
    @IBAction func exitMemeDetailView(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
    
    // set orientation to portrait mode (fix) in detailView
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.portrait
    }
    
    // disable orientation switch in detailView
    override var shouldAutorotate: Bool {
        
        return false
    }
}
