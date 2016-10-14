//
//  ViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 12.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibButton: UIBarButtonItem!
    @IBOutlet weak var inputFieldTop: UIOutlinedTextField!
    @IBOutlet weak var inputFieldBottom: UIOutlinedTextField!
    
    struct Meme {
    
        var textTop: String?
        var textBottom: String?
        var imageOrigin: UIImage?
        var image: UIImage?
    }
    
    let memeFontName = "Impact"
    let memeFontSize: CGFloat = 28.0
    let memeTextFieldTopDefault = "TOP"
    let memeTextFieldBottomDefault = "BOTTOM"
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    let imagePickerController = UIImagePickerController()
    var imagePickerSuccess: Bool = false

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
            UIAlertAction in
            
            return
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveImage() {
        
        let _ = Meme(
            textTop: inputFieldTop.text!,
            textBottom: inputFieldBottom.text!,
            imageOrigin: imagePickerView.image!,
            image: imagePickerView.image!
        )
    }
}

