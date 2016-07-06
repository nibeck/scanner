//
//  PersonViewController.swift
//  Scanner
//
//  Created by Mike Nibeck on 6/28/16.
//  Copyright © 2016 Mike Nibeck. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var person: Person?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let person = person {
            navigationItem.title = (person.firstName + " " + person.lastName)
            firstNameTextField.text = person.firstName
            lastNameTextField.text = person.lastName
            emailTextField.text = person.emailAddress
        }
        
        checkValidPersonData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        checkValidPersonData()
        navigationItem.title = textField.text
    }
    func checkValidPersonData() {
        // Disable the Save button if the text field is empty.
        if lastNameTextField.text == nil || emailTextField.text == nil {
            saveButton.enabled = false
        }
    }
    
    // MARK: Navigation
    // This method lets you configure a view controller before it's presented.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveButton === sender {
            //Save data from view
            person = Person()
            person!.firstName = firstNameTextField.text ?? ""
            person!.lastName = lastNameTextField.text ?? ""
            person!.emailAddress = emailTextField.text ?? ""
            person!.photo = photoImageView.image
        }
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
