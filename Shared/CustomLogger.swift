//
//  Logger.swift
//  NetworkMonitor
//
//  Created by Tony Gorez on 25/01/2024.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = MACH_SERVICE_NAME

    static let agent = Logger(subsystem: subsystem, category: "agent")
    static let app = Logger(subsystem: subsystem, category: "app")
}
