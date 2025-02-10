//
//  TableViewController.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/9/25.
//

import UIKit

class TableViewController: UITableViewController {
    var toDos: [String] = []

    func setNoDataLabel() {
        if toDos.isEmpty {
            let emptyLabel = UILabel()

            emptyLabel.text = "아직 할 일이 없어요.😭\n+ 버튼을 눌러 할 일을 추가해 보세요!😊"
            emptyLabel.textAlignment = .center
            emptyLabel.textColor = .black
            emptyLabel.font = UIFont.systemFont(ofSize: 18)
            emptyLabel.numberOfLines = 0
            emptyLabel.lineBreakMode = .byWordWrapping
            emptyLabel.sizeToFit()

            tableView.backgroundView = emptyLabel
        } else {
            tableView.backgroundView = nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNoDataLabel()
    }
}
