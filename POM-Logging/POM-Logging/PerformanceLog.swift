//
//  PerformanceLogger.swift
//  POM-Logging
//
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation

class PerformanceLog: NSObject {
    
    struct EnvironmentKeys {
        static let enabled = "PerfLogEnabled"
        static let clearOnLaunch = "PerfLogClearOnLaunch"
        static let filename = "PerfLogName"
    }
    
    struct Task: Equatable {
        let name: String
        let category: String
        let startDate: Date
        
        var duration: Double {
            let startTimestamp = startDate.timeIntervalSinceReferenceDate
            let endTimestamp = Date().timeIntervalSinceReferenceDate
            return Double(endTimestamp - startTimestamp)
        }
        
        public static func ==(lhs: Task, rhs: Task) -> Bool {
            if lhs.name != rhs.name { return false }
            if lhs.category != rhs.category { return false }
            if lhs.startDate != rhs.startDate { return false }
            return true
        }
    }
    
    static private var tasks: [Task] = []
    static private var adaptors: [LogAdaptor] = []
    static private var queue: DispatchQueue = DispatchQueue(label: "PerfLog")
    
    static private var launchTask: Task?
    
    static func attach(adaptor: LogAdaptor) {
        queue.async {
            adaptors.append(adaptor)
        }
    }
    
    static func launchStarted() {
        mark("Begin Session")
        launchTask = Task(name: "Launch", category: "Launch", startDate: Date())
    }
    
    static func launchFinished() {
        guard let launchTask = launchTask else { return }
        end(launchTask)
    }
    
    static func start(_ task: String, category: String) -> Task {
        let task = Task(name: task, category: category, startDate: Date())
        queue.async {
            tasks.append(task)
        }
        return task
    }
    
    static func end(_ task: Task) {
        logPerf("\(Date()), \(task.category), \(task.name), \(task.duration)")
        
        queue.async {
            tasks = tasks.filter({ $0 != task })
        }
    }
    
    static func mark(_ marker: String) {
        logPerf("\(Date()), Marker, \(marker), N/A")
    }
    
    static func measure(_ task: String, category: String, activity: (()->())) {
        let task = start(task, category: category)
        activity()
        end(task)
    }
    
    static func logPerf(_ s: String) {
        queue.async {
            for adaptor in adaptors {
                adaptor.log("⏱ \(s)")
            }
        }
    }
}

extension PerformanceLog {
    static var enabled: Bool {
        return (ProcessInfo.processInfo.environment[EnvironmentKeys.enabled] ?? "0") == "1"
    }
    
    static var clearFileOnLaunch: Bool {
        return (ProcessInfo.processInfo.environment[EnvironmentKeys.clearOnLaunch] ?? "0") == "1"
    }
    
    static var logFilename: String {
        return ProcessInfo.processInfo.environment[EnvironmentKeys.filename] ?? "Performance.csv"
    }
}
