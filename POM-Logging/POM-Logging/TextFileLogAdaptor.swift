//
//  TextFileLogger.swift
//  POM-Logging
//
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation

class TextFileLogAdaptor: LogAdaptor {
    let fileHandle: FileHandle?
    
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
    
    func log(_ s: String) {
        write(line: s)
    }
    
    func write(line: String) {
        guard let fileHandle = fileHandle else { return }
        guard let data = "\n\(line)".data(using: .utf8) else { return }
        
        fileHandle.seekToEndOfFile()
        fileHandle.write(data)
    }
}
