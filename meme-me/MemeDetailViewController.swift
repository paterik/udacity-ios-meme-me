//
//  MemeDetailViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 22.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//


import UIKit

class MemeDetailViewController: UIViewController {
   
    
    @IBOutlet weak var memeDetailView: UIImageView!
    
    var currentMeme: Meme?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        prepareDetailView()
    }
    
    @IBAction func exitMemeDetailView(_ sender: AnyObject) {
        
        dismiss(animated: true, completion: nil)
    }
}
