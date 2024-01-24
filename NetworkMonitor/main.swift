//
//  main.swift
//  NetworkMonitor
//
//  Created by Tony Gorez on 23/01/2024.
//

import Foundation

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = "com.tonygo.NetworkMonitorAgent"

    /// Logs the view cycles like a view that appeared.
    static let normal = Logger(subsystem: subsystem, category: "normal")
}

@objc protocol NetworkMonitorXPCProtocol {
    func getNetworkStatus(reply: @escaping (Bool) -> Void)
}

class NetworkMonitorXPCService: NSObject, NetworkMonitorXPCProtocol {
    func getNetworkStatus(reply: @escaping (Bool) -> Void) {
        // Implement your logic to determine the network status
        let networkStatus: Bool = true
        reply(networkStatus)
    }
}

Logger.normal.info("Start agent")

let delegate = NetworkMonitorXPCService()
let listener = NSXPCListener.init(machServiceName: "com.tonygo.NetworkMonitorAgent")
listener.delegate = delegate as? any NSXPCListenerDelegate
listener.resume()

Logger.normal.info("Agent started")

RunLoop.main.run()
