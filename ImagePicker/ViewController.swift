//
//  ViewController.swift
//  ImagePicker
//
//  Created by Kim Wayne on 5/30/17.
//  Copyright © 2017 GthomasWADE. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var socialBtn: UIBarButtonItem!
    @IBOutlet weak var cnclButton: UIBarButtonItem!
    
    @IBOutlet weak var txtTop: UITextField!
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var txtBottom: UITextField!
    @IBOutlet weak var tbImage: UIToolbar!
    @IBOutlet weak var pickBtn: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let memeTxtAttributes:[String:Any] =
        [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont( name: "HelveticaNeue-CondensedBlack", size: 40 )!,
            NSStrokeWidthAttributeName: NSNumber( value: -4.0 )
    ]
    
    struct MemeImage
    {
        var topText: String
        var bottomText: String
        var origImage: UIImage
        var memedImage: UIImage
    }
    
    var meme: MemeImage!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socialBtn.isEnabled = false
        txtTop.text = "Top"
        txtBottom.text = "Bottom"
        txtTop.textAlignment = NSTextAlignment.center
        txtBottom.textAlignment = NSTextAlignment.center
        txtTop.defaultTextAttributes = memeTxtAttributes
        txtBottom.defaultTextAttributes = memeTxtAttributes
        txtTop.delegate = self
        txtBottom.delegate = self
        ImagePickerView.contentMode = UIViewContentMode.scaleAspectFit
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    override func viewWillAppear(_ animated: Bool)
    {
        print( "MemeEditorViewController::viewWillAppear()" )
        
        super.viewWillAppear( animated )
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        print( "MemeEditorViewController::viewWillDisappear()" )
        
        super.viewWillDisappear( animated )
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification:Notification) {
        
        if txtBottom.isFirstResponder
        {
            // Updated to use * -1 per code review and post on Udacity forums.
            view.frame.origin.y = getKeyboardHeight( notification ) * -1
        }
    
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func save(_ memedImage: UIImage) {
        // Create the meme
        self.meme = MemeImage.init(topText: self.txtTop.text!, bottomText: self.txtBottom.text!, origImage: self.ImagePickerView.image!, memedImage: memedImage)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        tbImage.isHidden = true
        topToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        tbImage.isHidden = false
        topToolbar.isHidden = false
        
        return memedImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pickAnImage(_ sender: Any) {
        pickImageProcessing( sourceType: UIImagePickerControllerSourceType.photoLibrary )
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        
        pickImageProcessing( sourceType: UIImagePickerControllerSourceType.camera)
    }
    
    func pickImageProcessing ( sourceType: UIImagePickerControllerSourceType )
    {
        print( "MemeEditorViewController::pickImageProcessing()" )
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        
        self.present( pickerController, animated: true, completion: nil )
    }

    
    @IBAction func sharePic(_ sender: Any) {
        let memedImage = generateMemedImage()
        let socialController = UIActivityViewController( activityItems: [memedImage], applicationActivities: nil )
        
        socialController.completionWithItemsHandler =
            {
                activityType, completion, items, error in
                
                if completion
                {
                    self.save( memedImage )
                }
                self.dismiss( animated: true, completion: nil )
        }
        
        self.present( socialController, animated: true, completion: nil )
    }

    
    @IBAction func cancelMeme(_ sender: Any) {
        socialBtn.isEnabled = false
        txtTop.text = "Top"
        txtBottom.text = "Bottom"
        ImagePickerView.image = nil
        meme = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        if (textField.text == "Top" || textField.text == "Bottom") {
            textField.text = ""
        }}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("YOOOO ITS HAPPENING")
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print ("This is happening")
            ImagePickerView.contentMode = .scaleAspectFit
            ImagePickerView.image = image
            socialBtn.isEnabled = true
            cnclButton.isEnabled = true
            
        };dismiss( animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print ("This is happeening fo real")
        dismiss( animated: true, completion: nil)
    }
}

