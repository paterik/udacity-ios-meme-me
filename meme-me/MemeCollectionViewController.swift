//
//  MemeCollectionViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 18.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {

    //
    // MARK: CollectionViewController IBOutlets
    //
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //
    // MARK: Internal Variables And Constants
    //
    
    // constants
    let memeCellIdent = "CustomMemeCell"
    let memeCellImageCornerRadius: CGFloat = 4.0
    let memeCellFontSize: CGFloat = 14.0
    let memeCellFontName = "HelveticaNeue-CondensedBlack"

    // variables
    var noDataImageView: UIImageView!
    var memes: [Meme] { return (UIApplication.shared.delegate as! AppDelegate).memes }
    var appDelegate: AppDelegate { return (UIApplication.shared.delegate as! AppDelegate) }
    
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
        
        return appDelegate.memes.count
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
          cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let meme = appDelegate.memes[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memeCellIdent, for: indexPath) as! MemeCollectionViewCell
        
        cell.memeImage.image = meme.imageOrigin!
        cell.memeLabelTop.text = meme.textTop!
        cell.memeLabelBottom.text = meme.textBottom!
        cell.memeImage.layer.cornerRadius = memeCellImageCornerRadius
        
        layoutCellLabels(labels: [cell.memeLabelTop, cell.memeLabelBottom])
        
        return cell
    }
    
    override func collectionView(
        _ collectionView: UICollectionView,
          didSelectItemAt indexPath: IndexPath) {
        
        let detailViewController = storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let transition = CATransition()
        
        detailViewController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        detailViewController.currentMeme = appDelegate.memes[indexPath.row]
        
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        present(detailViewController, animated: false, completion: nil)
    }
    
    //
    // MARK: CollectionViewController Optional (Overrides)
    //
    
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
