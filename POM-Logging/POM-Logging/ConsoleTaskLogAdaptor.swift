//
//  ConsoleTaskLogAdaptor.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


class ConsoleTaskLogAdaptor: TaskLogAdaptor {

    func task(_ task: PerformanceLog.Task, didCrossWaypoint waypoint: String) {
        let message = "🏴 \(task.category) \(task.name): \(waypoint)"
        print(message)
    }

    func didEndTask(_ task: PerformanceLog.Task) {
        let message = "⏱ \(Date()), \(task.formattedDurationDescription)"
        print(message)
    } 
}
