//
//  TextFileTaskLogAdaptor.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


class TextFileTaskLogAdaptor {

    // MARK: - Properties

    let fileHandle: FileHandle?


    // MARK: - Initialization

    init(logName: String, clear: Bool) {
        let docsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let filePath = docsPath.appending("/\(logName)")
        
        if !FileManager.default.fileExists(atPath: filePath) {
            FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
        
        if clear {
            try? "".write(toFile: filePath, atomically: true, encoding: .utf8)
        }
        
        fileHandle = FileHandle(forWritingAtPath: filePath)
        print("📝 Log started at \(filePath)")
    }


    // MARK: - Public
    
    func write(line: String) {
        guard let fileHandle = fileHandle else { return }
        guard let data = "\n\(line)".data(using: .utf8) else { return }
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
}


// MARK: - <TaskLogAdaptor>

extension TextFileTaskLogAdaptor: TaskLogAdaptor {

    func task(_ task: PerformanceLog.Task, didCrossWaypoint waypoint: String) {
        let message = "🏴 \(task.category) \(task.name): \(waypoint)"
        write(line: message)
    }

    func didEndTask(_ task: PerformanceLog.Task) {
        let message = "⏱ \(Date()), \(task.formattedDurationDescription)"
        write(line: message)
    }
}
