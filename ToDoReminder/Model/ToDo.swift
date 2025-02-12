//
//  ToDo.swift
//  ToDoReminder
//
//  Created by 박지성 on 2/11/25.
//

import Foundation

struct ToDo: Codable {
    var title: String
    var content: String
    var date: Date
    var hasNotification: Bool
}
