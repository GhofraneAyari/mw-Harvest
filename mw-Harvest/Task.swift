//
//  Task.swift
//  mw-Harvest
//
//  Created by Ghofrane Ayari on 28/03/2022.
//

import Foundation
import SwiftUI

// Task Model

struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
