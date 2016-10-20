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

        let collectionCellPadding : CGFloat = 20.0
        var numberOfCellInRow : CGFloat = 2.0
        var collectionCellWidth : CGFloat = 128.0
        
        if UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.portrait {
            numberOfCellInRow = 3.0
        }
        
        collectionCellWidth = self.view.frame.width / numberOfCellInRow - collectionCellPadding

        return CGSize(
            width: collectionCellWidth,
            height: collectionCellWidth
        );
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int)
        -> Int {
        
        return memes.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath)
        -> UICollectionViewCell {
        
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellIdent, for: indexPath) as! MemeCollectionViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        cell.memeLabelTop.text = meme.textTop!
        cell.memeLabelBottom.text = meme.textBottom!
        
        layoutCellLabels(labels: [cell.memeLabelTop, cell.memeLabelBottom])
        
        return cell
    }
}
