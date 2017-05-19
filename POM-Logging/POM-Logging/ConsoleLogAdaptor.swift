//
//  ConsoleLogger.swift
//  POM-Logging
//
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation

class ConsoleLogAdaptor: LogAdaptor {
    func log(_ s: String) {
        print(s)
    }    
}
