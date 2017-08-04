//
//  LogAdaptorProtocol.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


protocol LogAdaptor {
    func didStartTask(_ task: PerformanceLog.Task)
    func didEndTask(_ task: PerformanceLog.Task)
}


extension LogAdaptor {
    func didStartTask(_ task: PerformanceLog.Task) { }
}
