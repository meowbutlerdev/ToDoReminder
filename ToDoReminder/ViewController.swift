//
//  ViewController.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/9/25.
//

import UIKit

protocol AddToDoDelegate: AnyObject {
    func addToDo(_ toDo: ToDo)
}

class ViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var notificationSwitch: UISwitch!

    weak var toDoDelegate: AddToDoDelegate?

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty else {
            let alert = UIAlertController(
                title: "제목을 입력해주세요.😭",
                message: "",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "확인👌", style: .default)

            alert.addAction(okAction)
            present(alert, animated: true)

            return
        }

        let toDo = ToDo(
            title: title,
            content: contentTextView.text,
            date: datePicker.date,
            hasNotification: notificationSwitch.isOn
        )

        toDoDelegate?.addToDo(toDo)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

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
