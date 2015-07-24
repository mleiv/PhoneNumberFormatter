//
//  ViewController.swift
//  PhoneNumberFormatter
//
//  Created by Emily Ivie on 7/20/15.
//  Copyright (c) 2015 Emily Ivie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var phone1: UITextField!
    @IBOutlet weak var phone2: UITextField!
    
    @IBOutlet weak var validationResponse: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatField(phone1)
        formatField(phone2)
    }
    
    var phoneFormatter = PhoneNumberFormatter() // (reset when loading different data into fields, with .reset() or new struct)

    /**
        Wired up to be called every time the field is edited.
    */
    @IBAction func formatField(sender: UITextField) {
        if sender == phone1 {
            sender.text = phoneFormatter.format(sender.text)
        } else {
            //multiple phone numbers being validated at once require an additional unique hash parameter so we can keep them straight
            sender.text = phoneFormatter.format(sender.text, hash: sender.hash)
        }
    }
    
    @IBAction func checkIsValid(sender: AnyObject) {
        var invalidMessage = String()
        if !phoneFormatter.isValid(phone1.text) {
            invalidMessage += "Phone 1 is invalid.\n"
        }
        if !phoneFormatter.isValid(phone2.text) {
            invalidMessage += "Phone 2 is invalid.\n"
        }
        validationResponse.text = invalidMessage
        validationResponse.hidden = invalidMessage.isEmpty
    }

}

