//
//  MemeEditViewControllerExtensions.swift
//  meme-me
//
//  Created by Patrick Paechnatz on 18.10.16.
//  Copyright © 2016 Patrick Paechnatz. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditViewController {
    
    //
    // MARK: ImagePicker Delegate Methods
    //
    
    func imagePickerController(
        _ picker: UIImagePickerController,
          didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = memeImageContentMode
            imagePickerView.image = pickedImage
            switchEditControls(activate: true)

            imagePickerSuccess = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController) {
        
        imagePickerSuccess = false
        switchEditControls(activate: false)
        
        dismiss(animated: true, completion: nil)
    }
    
    func loadImagePickerSource() {
        
        imagePickerController.allowsEditing = false
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //
    // MARK: Observer Methods
    //
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MemeEditViewController.keyboardWillAppear),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(MemeEditViewController.keyboardWillDisappear),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    func unSubscribeToKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillShow, object: nil
        )
        
        NotificationCenter.default.removeObserver(
            self, name: NSNotification.Name.UIKeyboardWillHide, object: nil
        )
    }
    
    func keyboardWillDisappear(notification: NSNotification) {
        
        prepareMemeControls(activate: true)
        view.frame.origin.y = 0
    }
    
    func keyboardWillAppear(notification: NSNotification) {
        
        prepareMemeControls(activate: false)
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
            if inputFieldBottom.isFirstResponder {
                self.view.frame.origin.y =  keyboardSize * -1
            }
        }
    }
    
    //
    // MARK: Image Handler Methods
    //
    
    func saveImageModel(memedImage: UIImage) {
        
        // init/define our memed image model struct
        let meme = Meme(
            textTop: inputFieldTop.text!,
            textBottom: inputFieldBottom.text!,
            imageOrigin: imagePickerView.image!,
            image: editMode == false ? memedImage : renderMemedImage(),
            fresh: true,
            created: Date()
        )
        
        // decide to append or replace meme based on current edit mode state flag
        if !editMode {
            appDelegate.addMeme(meme: meme)
        } else {
            appDelegate.replaceMeme(meme: meme, index: currentMemeRowIndex!)
        }
        
        // leave editView
        dismiss(animated: true, completion: nil)
    }
    
    func saveImage(renderedImage: UIImage) {
        
        // write incoming image to photo album
        UIImageWriteToSavedPhotosAlbum(renderedImage, self, #selector(handleImageStorage(_:didFinishSavingWithError:contextInfo:)), nil)
        
        saveImageModel(memedImage: renderedImage)
    }
    
    func shareImage(renderedImage: UIImage) {
        
        // open activitiy controller to share the incoming image
        let activityViewController = UIActivityViewController(activityItems: [renderedImage as UIImage], applicationActivities: nil)
        // let save the meme as model only if share was completed successfully
        activityViewController.completionWithItemsHandler = {(activity, completed, items, error) in
            
            if (completed) {
                self.saveImageModel(memedImage: renderedImage)
            }
        }
        
        // now show the activityController ...
        present(activityViewController, animated: true, completion: {})
    }
    
    // better image quality, using scale factor of main screen now
    func renderMemedImage() -> UIImage {
        
        let hasAlpha = false
        let scale: CGFloat = 0.0
        
        // Hide toolbar and navbar
        prepareToolBarControls(activate: false)
        
        UIGraphicsBeginImageContextWithOptions(view.frame.size, !hasAlpha, scale)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        prepareToolBarControls(activate: true)
        
        return memedImage
    }
    
    func handleImageStorage(
        _ image: UIImage,
          didFinishSavingWithError error: Error?,
          contextInfo: UnsafeRawPointer) {
        
        if let ioError = error {
            displayEditViewAlert(alertTitle: "Meme not saved!", alertMessage: ioError.localizedDescription, alertButtonText: "OK")
        } else {
            displayEditViewAlert(alertTitle: "Meme saved!", alertMessage: "Your memed image has been saved to your photos", alertButtonText: "OK")
        }
    }
    
    func displayEditViewAlert(alertTitle: String, alertMessage: String, alertButtonText: String) {
    
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alertButtonText, style: .default))
        present(alertController, animated: true)
    }
    
    func getPreConfiguredMemeTextViews() -> [MemeTextViewModel] {
        
        return [
            MemeTextViewModel(
                isTopText: true,
                isBottomText: false,
                defaultText: editMode ? currentMeme!.textTop! : memeTextViewTopDefault,
                verticalAlign: "top",
                textView: inputFieldTop!
            ),
            MemeTextViewModel(
                isTopText: false,
                isBottomText: true,
                defaultText: editMode ? currentMeme!.textBottom! : memeTextViewBottomDefault,
                verticalAlign: "bottom",
                textView: inputFieldBottom!
            ),
        ]
    }
    
    //
    // MARK: UI/Control Methods
    //
    
    func prepareControls() {
        
        imagePickerSuccess = false
        imagePickerController.delegate = self
        exportButton.isEnabled = false
        
        prepareMemeControls(activate: true)
        prepareEditControls(textViews: getPreConfiguredMemeTextViews(), activate: editMode)
        
        // prepare my controller to handly editMode conventions
        if editMode {
            saveButton.isEnabled = true
            imagePickerSuccess = true
            imagePickerView.image = currentMeme!.imageOrigin!
        }
        
        if !editMode {
            prepareCreationModeControls()
        }
        
        // always disable tabBarControls in editView
        tabBarController?.tabBar.isHidden = true
    }
    
    //
    // check for predefined font-range availability, switch to alternate one if given one not exist
    //
    func getAvailableMemeFontName(fontNamesAvailable: [String]) -> String {
        
        for fontName in fontNamesAvailable {
            if isFontNameAvailable(fontName: fontName) {
                return fontName
            }
        }
        
        return memeFontNameFailback
    }
    
    //
    // additional ui improvements of current view handling app create meme mode
    //
    func prepareCreationModeControls() {
        
        saveButton.isEnabled = false
        saveButton.style = UIBarButtonItemStyle.plain
        saveButton.image = nil;
    }
    
    //
    // prepare our meme input controls using dictionary of inputfields
    //
    func prepareEditControls(textViews: [MemeTextViewModel], activate: Bool) {
        
        //    NSStrokeColorAttributeName : UIColor.black,
        //    NSForegroundColorAttributeName : UIColor.white,
        //    NSFontAttributeName : UIFont(name: usedMemeFontName, size: memeFontSize)!
        
        usedMemeFontName = getAvailableMemeFontName(fontNamesAvailable: memeFontNames)
        for config in textViews {
            
            /*var myMutableString = NSMutableAttributedString()
            
            myMutableString.addAttribute(
                NSBackgroundColorAttributeName,
                value: UIColor.green,
                range: NSRange(
                    location: 0,
                    length: (config.defaultText?.lengthOfBytes(using: String.Encoding.utf8))!)
            )*/
            
            config.textView?.delegate = memeTextViewDelegate
            config.textView?.textAlignment = .center
            config.textView?.text = config.defaultText
            config.textView?.isHidden = !activate 
            config.textView?.contentDefault = (config.textView?.text)!
            config.textView?.verticalAlignment = config.verticalAlign!
            config.textView?.isTopText = config.isTopText!
            config.textView?.isBottomText = config.isBottomText!
            config.textView?.backgroundColor = UIColor.clear
        }
    }

    func prepareMemeControls(activate: Bool) {
    
        cameraButton.isEnabled = activate && isCameraAvailable()
        photoLibButton.isEnabled = activate && isLocalImageStockAvailable()
        exportButton.isEnabled = activate && isImageExportable()
    }
    
    func prepareToolBarControls(activate: Bool) {
        
        toolBarTop.isHidden = !activate
        toolBarBottom.isHidden = !activate
    }
    
    func switchEditControls(activate: Bool) {
        
        prepareEditControls(textViews: getPreConfiguredMemeTextViews(), activate: activate)
    }
    
    //
    // MARK: Internal Helper Methods
    //
    
    func isFontNameAvailable(fontName: String) -> Bool {
    
        for name in UIFont.familyNames {
            
            for fontFamilyName in UIFont.fontNames(forFamilyName: name) {
                if fontFamilyName == fontName {
                    return true
                }
            }
        }
        
        return false
    }
    
    func isImageExportable() -> Bool {
        return imagePickerSuccess
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
