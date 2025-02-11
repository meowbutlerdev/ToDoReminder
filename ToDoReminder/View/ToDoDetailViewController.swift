//
//  ToDoDetailViewController.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/9/25.
//

import UIKit

class ToDoDetailViewController: UIViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var notificationSwitch: UISwitch!

    var toDo: ToDo?
    var toDoIndex: Int?

    private let titlePlaceholder = "제목을 입력하세요."
    private let contentPlaceholder = "내용을 입력하세요."

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureWithToDo()
    }

    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, title != titlePlaceholder,
              !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert(title: "제목을 입력해주세요.😭", message: "")

            return
        }

        let toDo = ToDo(
            title: title,
            content: contentTextView.text == contentPlaceholder ? "" : contentTextView.text,
            date: datePicker.date,
            hasNotification: notificationSwitch.isOn
        )

        ToDoManager.shared.addOrUpdateToDo(toDo, at: toDoIndex)
        navigationController?.popViewController(animated: true)
    }

    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    private func setupUI() {
        titleTextField.delegate = self
        contentTextView.delegate = self

        setupFieldStyle(titleTextField)
        setupFieldStyle(contentTextView)

        datePicker.contentHorizontalAlignment = .left
    }

    private func configureWithToDo() {
        if let toDo = toDo {
            configureTextField(with: toDo.title)
            configureTextView(with: toDo.content)

            datePicker.date = toDo.date
            notificationSwitch.isOn = toDo.hasNotification
        } else {
            configureTextField(with: nil)
            configureTextView(with: nil)
        }
    }

    private func configureTextField(with text: String?) {
        setPlaceholder(for: titleTextField, text: text, placeholder: titlePlaceholder)
    }

    private func configureTextView(with text: String?) {
        setPlaceholder(for: contentTextView, text: text, placeholder: contentPlaceholder)
    }
}

extension ToDoDetailViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }

    func setupFieldStyle(_ field: UIView) {
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 8.0
    }

    func setPlaceholder(for field: UIView, text: String?, placeholder: String) {
        if let textField = field as? UITextField {
            textField.text = (text == nil || text!.isEmpty) ? placeholder : text
            textField.textColor = (text == nil || text!.isEmpty) ? .lightGray : .black
        } else if let textView = field as? UITextView {
            textView.text = (text == nil || text!.isEmpty) ? placeholder : text
            textView.textColor = (text == nil || text!.isEmpty) ? .lightGray : .black
        }
    }
}

extension ToDoDetailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == titlePlaceholder {
            textField.text = ""
            textField.textColor = .black
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        setPlaceholder(for: textField, text: textField.text, placeholder: titlePlaceholder)
    }
}

extension ToDoDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == contentPlaceholder {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceholder(for: textView, text: textView.text, placeholder: contentPlaceholder)
    }
}
