//
//  ViewControllerExtensions.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 13.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

extension ViewController {

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        
        if (imagePickerSuccess) {
            return
        }
        
        if (toInterfaceOrientation.isLandscape) {
            imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomeLandscape")
            imagePickerView.contentMode = .scaleAspectFit
        } else {
            imagePickerView.image = UIImage(imageLiteralResourceName: "WelcomePortrait")
            imagePickerView.contentMode = .scaleAspectFit
        }
    }
    
    func prepareControls() {
        
        imagePickerSuccess = false
        imagePickerController.delegate = self
        cameraButton.isEnabled = isCameraAvailable()
        photoLibButton.isEnabled = isLocalImageStockAvailable()
        prepareEditModeControls(activate: false)
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }
    
    func isPhotoLibrarayAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary)
    }
    
    func isSavedPhotosAlbumAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum)
    }
    
    func isLocalImageStockAvailable() -> Bool {
        return isPhotoLibrarayAvailable() || isSavedPhotosAlbumAvailable()
    }
}
