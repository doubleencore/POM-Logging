//
//  TextFileLogger.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


class TextFileLogAdaptor {

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


// MARK: - <LogAdaptor>

extension TextFileLogAdaptor: LogAdaptor {

    func didEndTask(_ task: PerformanceLog.Task) {
        let message = "⏱ \(Date()), \(task.formattedDurationDescription)"
        write(line: message)
    }
}
