//
//  ToDoListViewController.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/9/25.
//

import UIKit
import UserNotifications

class ToDoListViewController: UITableViewController {
    private var toDos: [ToDo] {
        return ToDoManager.shared.getToDos()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadToDos()
        checkFirstTimeNotificationRequest()
        updateBackgroundView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        saveToDos()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toToDoDetail",
           let detailVC = segue.destination as? ToDoDetailViewController {
            if let indexPath = sender as? IndexPath {
                detailVC.toDo = ToDoManager.shared.getToDo(at: indexPath.row)
                detailVC.toDoIndex = indexPath.row
            }
        }
    }

    func saveToDos() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(ToDoManager.shared.getToDos()) {
            UserDefaults.standard.set(encoded, forKey: "toDos")
        }
    }

    func loadToDos() {
        if let savedToDosData = UserDefaults.standard.data(forKey: "toDos") {
            let decoder = JSONDecoder()
            if let savedToDos = try? decoder.decode([ToDo].self, from: savedToDosData) {
                ToDoManager.shared.setToDos(savedToDos)
            }
        }
    }
}

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateBackgroundView()

        return toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toDo", for: indexPath)
        cell.textLabel?.text = toDos[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDoManager.shared.removeToDo(at: indexPath.row)
            saveToDos()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateBackgroundView()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toToDoDetail", sender: indexPath)
    }
}

extension ToDoListViewController {
    private func updateBackgroundView() {
        tableView.backgroundView = toDos.isEmpty ? noDataLabel() : nil
    }

    private func noDataLabel() -> UILabel {
        let label = UILabel()
        label.text = "아직 할 일이 없어요.😭\n+ 버튼을 눌러 할 일을 추가해 보세요!😊"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()

        return label
    }
}

extension ToDoListViewController {
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    self.showSettingsAlert()
                }
            }
        }
    }

    func checkFirstTimeNotificationRequest() {
        let hasRequestedNotification = UserDefaults.standard.bool(forKey: "hasRequestedNotification")

        if !hasRequestedNotification {
            requestNotificationPermission()
            UserDefaults.standard.set(true, forKey: "hasRequestedNotification")
        }
    }
}
