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

    //
    // MARK: CollectionViewController IBOutlets
    //
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //
    // MARK: CollectionViewController variables and constants
    //
    
    let memeCellIdent = "CustomMemeCell"
    let memeCellImageCornerRadius: CGFloat = 4.0

    var noDataImageView: UIImageView!
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    
    //
    // MARK: CollectionViewController Overrides, LifeCycle Methods
    //
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        refreshCollectionView()
    }
    
    override func willRotate(
        to toInterfaceOrientation: UIInterfaceOrientation,
        duration: TimeInterval) {
        
        collectionView!.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
          numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let editViewController = storyboard!.instantiateViewController(withIdentifier: "MemeEditViewController") as! MemeEditViewController
        editViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        editViewController.presentationMode = true
        editViewController.currentMeme = memes[indexPath.row]
        editViewController.currentMemeRowIndex = indexPath.row
        
        present(editViewController, animated: true, completion: nil)
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
          cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let meme = memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellIdent, for: indexPath) as! MemeCollectionViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        cell.memeLabelTop.text = meme.textTop!
        cell.memeLabelBottom.text = meme.textBottom!
        cell.memeImage.layer.cornerRadius = memeCellImageCornerRadius
        
        layoutCellLabels(labels: [cell.memeLabelTop, cell.memeLabelBottom])
        
        return cell
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
          layout collectionViewLayout: UICollectionViewLayout,
          sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var collectionCellWidth: CGFloat!
        var collectionCellHeight: CGFloat!
        var collectionCellPadding: CGFloat = 12.0
        var collectionCellSpacing: CGFloat = 8.0
        var numberOfCellInRow: CGFloat = 2.0
        
        if UIApplication.shared.statusBarOrientation != UIInterfaceOrientation.portrait {
            numberOfCellInRow = 3.0
            collectionCellPadding = 8.0
            collectionCellSpacing = 4.0
        }
        
        collectionCellWidth = (view.frame.width / numberOfCellInRow) - collectionCellPadding
        collectionCellHeight = collectionCellWidth
        
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellHeight)
        flowLayout.minimumInteritemSpacing = collectionCellSpacing
        flowLayout.minimumLineSpacing = collectionCellSpacing
        
        return CGSize(
            width: collectionCellWidth,
            height: collectionCellHeight
        );
    }
}
