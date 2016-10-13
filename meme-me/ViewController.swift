//
//  ViewController.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 12.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibButton: UIBarButtonItem!
    @IBOutlet weak var inputFieldTop: UITextField!
    @IBOutlet weak var inputFieldBottom: UITextField!
    
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFill
            imagePickerView.image = pickedImage
            prepareEditModeControls(activate: true)
            imagePickerSuccess = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController) {
        
        imagePickerSuccess = false
        prepareEditModeControls(activate: false)
        
        dismiss(animated: true, completion: nil)
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
            let photoLibAction = UIAlertAction(title: "My Photos", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.imagePickerController.sourceType = .photoLibrary
                self.loadImagePickerSource()
            }
            alertController.addAction(photoLibAction)
        }
        
        if isSavedPhotosAlbumAvailable() {
            let photoAlbumAction = UIAlertAction(title: "My Photo-Album", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.imagePickerController.sourceType = .savedPhotosAlbum
                self.loadImagePickerSource()
            }
            alertController.addAction(photoAlbumAction)
        }
        
        // add Cancel action
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            return
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func loadImagePickerSource() {
        
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

