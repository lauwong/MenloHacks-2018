//
//  ViewController.swift
//  FamilyCheckIn
//
//  Created by Lauren Wong on 3/10/18.
//  Copyright © 2018 MenloHacks. All rights reserved.
//

import UIKit
import ContactsUI
import Firebase

class NewCheckInViewController: UIViewController, CNContactPickerDelegate, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var targetUserLabel: UILabel!
    @IBOutlet weak var checkInScrollView: UIScrollView!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var numberOfTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var intervalTextField: UITextField!
    @IBOutlet weak var endingAtLabel: UILabel!
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let intervalPicker = UIDatePicker()
    var selectedContact = CNContact()
    var timeInterval = TimeInterval()
    let ref = Database.database().reference(withPath: "activeNotifications")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewCheckInViewController.dismissKeyboard))
        setupViewResizerOnKeyboardShown()
        createDatePicker()
        createTimePicker()
        createIntervalPicker()
        
        checkInScrollView.delegate = self
        startDateTextField.delegate = self
        numberOfTextField.delegate = self
        startTimeTextField.delegate = self
        intervalTextField.delegate = self
        
        checkInScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.size.height+100)
        view.addGestureRecognizer(tap)
        presentContactPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let name = contact.givenName + " " + contact.familyName
        selectedContact = contact
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
        let phoneNumber = (selectedContact.phoneNumbers[0].value).value(forKey: "digits") as! String
        let startDate = startDateTextField.text!
        let startTime = startTimeTextField.text!
        let numberOf = Int(numberOfTextField.text!)!
        let interval = intervalTextField.text!
        
        let notificationItem = NotificationEvent(notifier: UIDevice.current.identifierForVendor!.uuidString, receiver: phoneNumber, date: startDate, numberOf: numberOf, startTime: startTime, interval: interval)
        
        if notificationItem == nil {
            let alertEmpty = UIAlertController(title: "Empty Field",
                                               message: "You have an empty field. Please fill every field to submit.",
                                               preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Dismiss",
                                             style: .default)
            alertEmpty.addAction(cancelAction)
            present(alertEmpty, animated: true, completion: nil)
        } else{
            //3
            let notificationItemRef = self.ref.childByAutoId()
            
            // 4
            notificationItemRef.setValue(notificationItem?.toAnyObject())
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func checkEndTime() {
        //var date = Date()
        if let repetitions = numberOfTextField.text, let intRepetitions = Int(repetitions) {
            if let startDate = startDateTextField.text, let startTime = startTimeTextField.text, let startInterval = intervalTextField.text {
                let timeFormatter = DateFormatter()
                timeFormatter.locale = Locale(identifier: "en_US_POSIX")
                timeFormatter.dateFormat = "hh:mm a"
                let formattedStartTime = timeFormatter.date(from: startTime)
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "mm/dd/yy"
                let formattedStartDate = dateFormatter.date(from: startDate)
                
                let intervalFormatter = DateFormatter()
                intervalFormatter.locale = Locale(identifier: "en_US_POSIX")
                intervalFormatter.dateFormat = "hh:mm:ss"
                let formattedInterval = intervalFormatter.date(from: startInterval)
                
                if let moreTime = formattedStartTime, let moreDates = formattedStartDate, let moreIntervals = formattedInterval {
                    let calendar = Calendar.current
                    let timeComponent = calendar.dateComponents([.hour, .minute], from: moreTime)
                    var dateComponent = calendar.dateComponents([.year, .month, .day], from: moreDates)
                    var intervalComponent = calendar.dateComponents([.hour, .minute, .second], from: moreIntervals)
                    
                    var mergedComponents = DateComponents()
                    mergedComponents.year = dateComponent.year
                    mergedComponents.month = dateComponent.month
                    mergedComponents.day = dateComponent.day
                    mergedComponents.hour = timeComponent.hour
                    mergedComponents.minute = timeComponent.minute
                    mergedComponents.second = 0
                    
                    if let combinedDate = calendar.date(from: mergedComponents) {
                        if let endDateHour = calendar.date(byAdding: .hour, value: intRepetitions * intervalComponent.hour!, to: combinedDate), let endDateCombined = calendar.date(byAdding: .minute, value: intRepetitions * intervalComponent.minute!, to: endDateHour) {
                        //let endDate = combinedDate.addingTimeInterval(timeInterval * doubleRepetitions)
                            endingAtLabel.text = "Currently ending at : " + String("\(endDateCombined)")
                        }
                    }
                }
            }
        }
    }
    
}

extension NewCheckInViewController {
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NewCheckInViewController.keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(NewCheckInViewController.keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: window.origin.y + window.height - keyboardSize.height)
        } else {
            debugPrint("We're showing the keyboard and either the keyboard size or window is nil: panic widely.")
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let viewHeight = self.view.frame.height
            self.view.frame = CGRect(x: self.view.frame.origin.x,
                                     y: self.view.frame.origin.y,
                                     width: self.view.frame.width,
                                     height: viewHeight + keyboardSize.height)
        } else {
            debugPrint("We're about to hide the keyboard and the keyboard size is nil. Now is the rapture.")
        }
    }
}

extension NewCheckInViewController {
    func createDatePicker(){
        //format
        datePicker.datePickerMode = .date
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //flexible space
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        startDateTextField.inputAccessoryView = toolbar
        
        //assigning datepicker to textfield
        startDateTextField.inputView = datePicker
    }
    
    @objc func dateDonePressed(){
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_US")
        startDateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        checkEndTime()
    }
}

extension NewCheckInViewController {
    func createTimePicker(){
        //format
        timePicker.datePickerMode = .time
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //flexible space
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(timeDonePressed))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        startTimeTextField.inputAccessoryView = toolbar
        
        //assigning datepicker to textfield
        startTimeTextField.inputView = timePicker
    }
    
    @objc func timeDonePressed(){
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        startTimeTextField.text = dateFormatter.string(from: timePicker.date)
        self.view.endEditing(true)
        checkEndTime()
    }
}

extension NewCheckInViewController {
    func createIntervalPicker(){
        //format
        intervalPicker.datePickerMode = .countDownTimer
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        //flexible space
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        //bar button item
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(intervalDonePressed))
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        intervalTextField.inputAccessoryView = toolbar
        
        //assigning datepicker to textfield
        intervalTextField.inputView = intervalPicker
    }
    
    @objc func intervalDonePressed(){
        let time = Int(intervalPicker.countDownDuration)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        //format date
        intervalTextField.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        timeInterval = TimeInterval(time)
        self.view.endEditing(true)
        checkEndTime()
    }
}

