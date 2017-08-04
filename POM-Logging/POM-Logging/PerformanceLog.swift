//
//  PerformanceLogger.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


class PerformanceLog: NSObject {
    
    struct EnvironmentKeys {
        static let enabled = "PerformanceLogEnabled"
        static let clearOnLaunch = "PerformanceLogClearOnLaunch"
        static let filename = "PerformanceLogName"
    }
    
    struct Task: Equatable, CustomStringConvertible {
        let name: String
        let category: String
        let startDate: Date
        
        var duration: Double {
            let startTimestamp = startDate.timeIntervalSinceReferenceDate
            let endTimestamp = Date().timeIntervalSinceReferenceDate
            return Double(endTimestamp - startTimestamp)
        }

        var description: String {
            let value = "\(name): (\(category)) started at \(startDate)"
            return value
        }

        var formattedDurationDescription: String {
            let value = "(\(category)) \(name): \(duration)"
            return value
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
    static private var queue: DispatchQueue = DispatchQueue(label: "PerformanceLog")
    
    static private var launchTask: Task?
    
    static func attach(adaptor: LogAdaptor) {
        queue.async {
            adaptors.append(adaptor)
        }
    }
    
    static func launchStarted() {
        launchTask = start("Launch", category: "Launch")
    }
    
    static func launchFinished() {
        guard let launchTask = launchTask else { return }
        end(launchTask)
    }
	
    @discardableResult
    static func start(_ task: String, category: String) -> Task {
        let task = Task(name: task, category: category, startDate: Date())

        notifyAdaptorsDidStartTask(task)

        queue.async {
            tasks.append(task)
        }

        return task
    }
    
    static func end(_ task: Task) {
        notifyAdaptorsDidEndTask(task)
        
        queue.async {
            tasks = tasks.filter({ $0 != task })
        }
    }

    /// Method to end a specific task by name.
    /// This method is provided for edge cases where it is difficult to maintain a reference to the `Task` object returned by calling start(task: category:)
    /// Ex: A task should be started in the AppDelegate but needs to be ended when a particular view controller has appeared.
    /// Without careful consideration it is possible to have multiple `Task` objects running with the same name and this method will only end the first one it finds.
    static func end(taskNamed name: String) {
        var foundTask: Task?

        queue.sync {
            foundTask = tasks.filter { $0.name == name }.first
        }

        if let task = foundTask {
            end(task)
        }
    }
    
    static func measure(_ task: String, category: String, activity: (()->())) {
        let task = start(task, category: category)
        activity()
        end(task)
    }

    private static func notifyAdaptorsDidStartTask(_ task: PerformanceLog.Task) {
        queue.async {
            adaptors.forEach { $0.didStartTask(task) }
        }
    }

    private static func notifyAdaptorsDidEndTask(_ task: PerformanceLog.Task) {
        queue.async {
            adaptors.forEach { $0.didEndTask(task) }
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
