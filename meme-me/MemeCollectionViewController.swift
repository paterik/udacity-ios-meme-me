//
//  MemeCollectionViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 18.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UICollectionViewController {

    let memeCellIdent = "CustomMemeCell"
    
    var noDataImageView: UIImageView!
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    
    //
    // MARK: TableViewController Overrides, LifeCycle Methods
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initCollectionView()
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfCellInRow : Int = 4
        let padding : Int = 0
        let collectionCellWidth : CGFloat = (self.view.frame.size.width/CGFloat(numberOfCellInRow)) - CGFloat(padding)
        
        print (CGSize(width: collectionCellWidth , height: collectionCellWidth))
        
        return CGSize(width: collectionCellWidth , height: collectionCellWidth)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellIdent, for: indexPath) as! MemeCollectionViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        
        return cell
    }
}
