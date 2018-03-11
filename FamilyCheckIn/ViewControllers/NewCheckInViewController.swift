//
//  ViewController.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import ContactsUI

class NewCheckInViewController: UIViewController, CNContactPickerDelegate {

    @IBOutlet weak var targetUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        presentContactPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        targetUserLabel.text = "Target User: " + name
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }
    
    func presentContactPicker() {
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        self.present(cnPicker, animated: true, completion: nil)
    }

    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeUserPressed(_ sender: UIButton) {
        presentContactPicker()
    }
    
    @IBAction func askPressed(_ sender: UIBarButtonItem) {
        
    }
}

