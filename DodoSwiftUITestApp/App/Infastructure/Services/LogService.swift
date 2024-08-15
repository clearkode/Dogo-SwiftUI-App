//
//  LogService.swift
//  DogoSwiftUITestApp
//
//  Created by Dev on 09/06/2024.
//

import Foundation
import os

struct LogService {
    static private let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "LogService")
    static func log(_ message: String?) {
        if let message = message {
            logger.log("DEBUG: \(message, privacy: .public)")
        } else {
            logger.log("DEBUG: Empty log")
        }
    }
}
