//
//  main.swift
//  NetworkMonitor
//
//  Created by Tony Gorez on 23/01/2024.
//

import Foundation
import OSLog

class NetworkMonitorXPCService: NSObject, NetworkMonitorXPCProtocol, NSXPCListenerDelegate {
    func getNetworkStatus(reply: @escaping (Bool) -> Void) {
        // Implement your logic to determine the network status
        let networkStatus: Bool = true
        reply(networkStatus)
    }
    
    /// This method is where the NSXPCListener configures, accepts, and resumes a new incoming NSXPCConnection.
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        Logger.agent.debug("In listener")
        
        // Configure the connection.
        // First, set the interface that the exported object implements.
        newConnection.exportedInterface = NSXPCInterface(with: NetworkMonitorXPCProtocol.self)
        
        Logger.agent.debug("After Exported Interface")
        
        // Next, set the object that the connection exports. All messages sent on the connection to this service will be sent to the exported object to handle. The connection retains the exported object.
        newConnection.exportedObject = self
        
        Logger.agent.debug("After Exported Object")
        
        // Resuming the connection allows the system to deliver more incoming messages.
        newConnection.resume()
        
        Logger.agent.debug("After Exported Resume")
        
        // Returning true from this method tells the system that you have accepted this connection. If you want to reject the connection for some reason, call invalidate() on the connection and return false.
        return true
    }
}

Logger.agent.info("Start agent")

let delegate = NetworkMonitorXPCService()
let listener = NSXPCListener.init(machServiceName: MACH_SERVICE_NAME)
listener.delegate = delegate
listener.resume()

Logger.agent.info("Agent started")

RunLoop.main.run()
