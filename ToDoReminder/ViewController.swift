//
//  ViewController.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/9/25.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        datePicker.contentHorizontalAlignment = .left
        
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 1
        titleTextField.layer.cornerRadius = 8.0
        
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.cornerRadius = 8.0
    }
}

