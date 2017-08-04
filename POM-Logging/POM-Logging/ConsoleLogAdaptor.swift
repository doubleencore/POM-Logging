//
//  ConsoleLogger.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


class ConsoleLogAdaptor: LogAdaptor {

    func didEndTask(_ task: PerformanceLog.Task) {
        let message = "⏱ \(Date()), \(task.formattedDurationDescription)"
        print(message)
    } 
}
