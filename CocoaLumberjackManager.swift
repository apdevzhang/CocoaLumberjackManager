//
//  CocoaLumberjackManager.swift
//  SwiftyFramework
//
//  Created by BANYAN on 2020/3/13.
//  Copyright © 2020 BANYAN. All rights reserved.
//

import UIKit
import CocoaLumberjack

class CocoaLumberjackManager: NSObject {
    static let shared = CocoaLumberjackManager()
    
    /// 配置`CocoaLumberjack`
    func configuration() {
        DDTTYLogger.sharedInstance.logFormatter = CocoaLumberjackLogFormatter()
        
        /// TTY = `Xcode console`
        DDLog.add(DDTTYLogger.sharedInstance)
        
        /// ASL =` Apple System Logs`
        DDLog.add(DDOSLogger.sharedInstance)
        
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
    }
}

class CocoaLumberjackLogFormatter: DDDispatchQueueLogFormatter {
        
    private func formatterLogFlag(message logMessage: DDLogMessage) -> String {
        let logFlag = logMessage.flag
      
        if logFlag.contains(.error) {
            return "Error"
        } else if logFlag.contains(.warning) {
            return "Warning"
        } else if logFlag.contains(.info) {
            return "Info"
        } else if logFlag.contains(.debug) {
            return "Debug"
        } else {
            return "Verbose"
        }
    }
    
    override func format(message logMessage: DDLogMessage) -> String? {        
        let timeString = dateFormatter.string(from: logMessage.timestamp)
        let logFlagString = formatterLogFlag(message: logMessage)
        let fileString = logMessage.file.lastPathComponent
        let lineString =  "line(\(String(logMessage.line)))"
        let functionString = logMessage.function ?? "unrecognized function"
        let logMessageString = logMessage.message

        let outputString = "\(timeString) \(logFlagString) \(fileString) \(lineString) \(functionString) \(logMessageString)"
        
        return outputString
    }
        
    lazy var dateFormatter = DateFormatter().then { (x) in
        x.formatterBehavior = .behavior10_4
        x.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
}
