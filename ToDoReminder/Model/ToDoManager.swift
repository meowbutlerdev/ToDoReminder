//
//  ToDoManager.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/11/25.
//

import Foundation

class ToDoManager {
    static let shared = ToDoManager()
    private init() {}

    private var toDos: [ToDo] = []

    func getToDos() -> [ToDo] {
        return toDos
    }

    func addOrUpdateToDo(_ toDo: ToDo, at index: Int?) {
        if let index = index {
            toDos[index] = toDo
        } else {
            toDos.append(toDo)
        }
    }

    func removeToDo(at index: Int) {
        toDos.remove(at: index)
    }

    func count() -> Int {
        return toDos.count
    }

    func getToDo(at index: Int) -> ToDo? {
        return toDos.indices.contains(index) ? toDos[index] : nil
    }
}
