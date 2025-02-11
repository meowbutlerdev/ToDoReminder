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
        requestNotificationPermission()
        updateBackgroundView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAddToDo",
           let detailVC = segue.destination as? ToDoDetailViewController {
            if let indexPath = sender as? IndexPath {
                detailVC.toDo = ToDoManager.shared.getToDo(at: indexPath.row)
                detailVC.toDoIndex = indexPath.row
            }
        }
    }
}

extension ToDoListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "toDo",
            for: indexPath
        )
        cell.textLabel?.text = toDos[indexPath.row].title

        return cell
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ToDoManager.shared.removeToDo(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            updateBackgroundView()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toAddToDo", sender: indexPath)
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
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            if !granted {
                DispatchQueue.main.async {
                    self.showSettingsAlert()
                }
            }
        }
    }

    func showSettingsAlert() {
        let alert = UIAlertController(
            title: "알림이 거부되었습니다.",
            message: "알림을 받으려면 설정에서 권한을 허용해주세요.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        present(alert, animated: true)
    }
}
