//
//  ItemViewController.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/23/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIPopoverPresentationControllerDelegate {
    
    // MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var barcodeTextField: UITextField!
    @IBOutlet weak var assignedToTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    var item: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        if let item = item {
            navigationItem.title = item.name
            nameTextField.text = item.name
            barcodeTextField.text = item.barcode
            photoImageView.image = item.photo
            assignedToTextField.text = item.assignedTo
        }
        
        checkValidItemName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            //Save data from view
            item = Item()
            item!.name = nameTextField.text ?? ""
            item!.photo = photoImageView.image
            item!.barcode = barcodeTextField.text ?? ""
            item!.assignedTo =  assignedToTextField.text ?? ""
        }
        
        //segue for the popover configuration window
        if segue.identifier == "ListPeople" {
            let popoverViewController = segue.destinationViewController 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: UITextFieldDelegate    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.enabled = false
    }
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidItemName()
        navigationItem.title = textField.text
    }
    func checkValidItemName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.enabled = !text.isEmpty
    }
    
    // MARK: - Actions
    @IBAction func captureBarcode(sender: AnyObject) {
    }
    
    @IBAction func assignUser(sender: AnyObject) {

    }
    
    @IBAction func selectImageFromLibrary(sender: AnyObject) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // The info dictionary contains multiple representations of the image, and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func cancelPressed(sender: AnyObject) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }

}
