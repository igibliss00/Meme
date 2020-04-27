//
//  ViewController.swift
//  Meme
//
//  Created by J on 2020-04-25.
//  Copyright © 2020 J. All rights reserved.
//

import UIKit

class ViewController: UIViewController,  UITextFieldDelegate,  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -3.0
    ]
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.textAlignment = .center
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = "TOP"
        bottomTextField.textAlignment = .center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        shareButtonEnabled(isEnabled: false)
        bottomTextField.text = "BOTTOM"
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    //MARK: - Image picker
    
    func pickImage(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func camera(_ sender: Any) {
        pickImage(source: UIImagePickerController.SourceType.camera)
    }
    
    @IBAction func pickFromPhotoLibrary(_ sender: Any) {
        pickImage(source: UIImagePickerController.SourceType.photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var newImage: UIImage
        
        if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            newImage = pickedImage
        } else if let pickedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            newImage = pickedImage
        } else {
            return
        }
        
        imageView.image = newImage
        shareButtonEnabled(isEnabled: true)
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Keyboard show/hide
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        if view.frame.origin.y == 0 && !self.topTextField.isEditing {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - generate meme, save, and share
    func generateMemedImage() -> UIImage {
        
        //        toolBarVisible(isVisible: false)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //        toolBarVisible(isVisible: true)
        
        return memedImage
    }
    
    @IBAction func shareButton(_ sender: UIBarButtonItem) {
        
        if let topText = topTextField.text, let bottomText = bottomTextField.text {
            let memedImage = generateMemedImage()
            let finishedMeme = Meme(topText: topText, bottomText: bottomText, originalImage: imageView.image!, memedImage: memedImage)
            let ac = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            present(ac, animated: true, completion: nil)
            ac.completionWithItemsHandler = { activity, success, items, error in
                if success {
                    let object = UIApplication.shared.delegate
                    let appDelegate = object as! AppDelegate
                    appDelegate.memes.append(finishedMeme)
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    print("cancel")
                }
                if let shareError = error {
                    print("error while sharing: \(shareError.localizedDescription)")
                }
            }
        }
    }
    
    //MARK: - show/hide the toolbar
    
    func toolBarVisible(isVisible: Bool) {
        if isVisible == true {
            toolBar.isHidden = false
        } else {
            toolBar.isHidden = true
        }
    }
    
    
    //MARK: - show/hide share button
    func shareButtonEnabled(isEnabled: Bool) {
        if isEnabled {
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }
    
    
    //MARK: - cancel button
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil
        shareButtonEnabled(isEnabled: false)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


