//
//  TaskLogAdaptor.swift
//  Copyright © 2017 Possible Mobile. All rights reserved.
//

import Foundation


protocol TaskLogAdaptor {
    func didStartTask(_ task: PerformanceLog.Task)
    func task(_ task: PerformanceLog.Task, didCrossWaypoint waypoint: String)
    func didEndTask(_ task: PerformanceLog.Task)
}


extension TaskLogAdaptor {
    func didStartTask(_ task: PerformanceLog.Task) { }
}
