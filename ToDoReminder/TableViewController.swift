//
//  TableViewController.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/9/25.
//

import UIKit
import Foundation

class TableViewController: UITableViewController, AddToDoDelegate {
    var toDos: [ToDo] = []

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

    func addToDo(_ toDo: ToDo) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            toDos[selectedIndexPath.row] = toDo
        } else {
            toDos.append(toDo)
        }

        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddToDo" {
            if let addToDoVC = segue.destination as? ViewController {
                addToDoVC.toDoDelegate = self

                if let indexPath = sender as? IndexPath {
                    addToDoVC.toDo = toDos[indexPath.row]
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNoDataLabel()
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "toDo",
            for: indexPath
        )
        cell.textLabel?.text = toDos[indexPath.row].title

        setNoDataLabel()

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            toDos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        setNoDataLabel()
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "toAddToDo", sender: indexPath)
    }
}

class ToDo {
    var title: String
    var content: String
    var date: Date
    var hasNotification: Bool

    init(title: String, content: String, date: Date, hasNotification: Bool) {
        self.title = title
        self.content = content
        self.date = date
        self.hasNotification = hasNotification
    }
}
