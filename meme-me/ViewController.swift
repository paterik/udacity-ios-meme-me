//
//  ViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 12.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //
    // MARK: Outlets
    //
    
    @IBOutlet weak var toolBarBottom: UIToolbar!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibButton: UIBarButtonItem!
    @IBOutlet weak var exportButton: UIBarButtonItem!
    @IBOutlet weak var inputFieldTop: UIOutlinedTextField!
    @IBOutlet weak var inputFieldBottom: UIOutlinedTextField!
    
    //
    // MARK: Internal Variables
    //
    
    let memeFontName = "Impact"
    let memeFontSize: CGFloat = 28.0
    let memeTextFieldTopDefault = "TOP"
    let memeTextFieldBottomDefault = "BOTTOM"
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    let imagePickerController = UIImagePickerController()
    var imagePickerSuccess: Bool = false
    
    //
    // MARK: Meme Model Definition
    //
    
    struct Meme {
        
        var textTop: String?
        var textBottom: String?
        var imageOrigin: UIImage?
        var image: UIImage?
    }
    
    //
    // MARK: ViewController Overrides, LifeCycle Methods
    //

    override func viewDidLoad() {
        
        super.viewDidLoad()
        prepareControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unSubscribeToKeyboardNotifications()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        if (imagePickerSuccess) {
            return
        }
        
        imagePickerView.contentMode = .scaleAspectFit
        imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomePortrait")
        
        if (toInterfaceOrientation.isLandscape) {
            imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomeLandscape")
        }
    }
    
    //
    // MARK: Actions
    //
    
    @IBAction func exportImage(_ sender: AnyObject) {
        
        // generate our memed image
        let sourceImage: UIImage = renderMemedImage()
        
        // Create the subMenu controller (using alertViewController)
        let alertController = UIAlertController(
            title: "Export your image",
            message: "Choose your export method",
            preferredStyle: .alert)
        
        let normalExportAction = UIAlertAction(title: "save image", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.saveImage(renderedImage: sourceImage)
        }
        
        let sharedExportAction = UIAlertAction(title: "share image", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.shareImage(renderedImage: sourceImage)
        }
        
        // Add Basic actions
        alertController.addAction(normalExportAction)
        alertController.addAction(sharedExportAction)
        
        // Add Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in return
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func pickCameraImage(_ sender: AnyObject) {
    
        self.imagePickerController.sourceType = .camera
        self.loadImagePickerSource()
    }
    
    @IBAction func pickLocalStockImage(_ sender: AnyObject) {
        
        // Create the subMenu controller (using alertViewController)
        let alertController = UIAlertController(
            title: "Pick an image",
            message: "Choose your image location",
            preferredStyle: .alert)
        
        // Create the photo selection related actions
        if isPhotoLibrarayAvailable() {
            
            let photoLibAction = UIAlertAction(title: "from photos", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.imagePickerController.sourceType = .photoLibrary
                self.loadImagePickerSource()
            }
            
            alertController.addAction(photoLibAction)
        }
        
        if isSavedPhotosAlbumAvailable() {
            
            let photoAlbumAction = UIAlertAction(title: "from album", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.imagePickerController.sourceType = .savedPhotosAlbum
                self.loadImagePickerSource()
            }
            
            alertController.addAction(photoAlbumAction)
        }
        
        // Add Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in return
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
}

