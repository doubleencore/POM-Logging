//
//  OperationPerformanceObserver.swift
//  POM-Logging
//
//  Created by Bradford Dillon on 5/18/17.
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation

extension PerformanceLog {
    static func measure(operation: Operation, name: String, category: String) {
        let observer = OperationPerformanceObserver(name: name, category: category)
        operation.addObserver(observer)
    }
}

class OperationPerformanceObserver: OperationObserver {
    
    let name: String
    let category: String
    var task: PerformanceLog.Task?
    
    init(name: String, category: String) {
        self.name = name
        self.category = category
    }
    
    func operationDidStart(_ operation: Operation) {
        task = PerformanceLog.start(name, category: category)
    }
    
    func operation(_ operation: Operation, didProduceOperation newOperation: Foundation.Operation) {
        return
    }
    
    func operationDidFinish(_ operation: Operation, errors: [NSError]) {
        guard let task = task else { return }
        PerformanceLog.end(task)
    }
}
