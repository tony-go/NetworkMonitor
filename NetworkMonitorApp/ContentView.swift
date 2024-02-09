//
//  ContentView.swift
//  NetworkMonitorApp
//
//  Created by Tony Gorez on 25/01/2024.
//

import SwiftUI
import Foundation
import ServiceManagement

class NetworkMonitorXPCClient: NetworkMonitorXPCProtocol {

    private let connection: NSXPCConnection

    init() {
        let service = SMAppService.agent(plistName: "com.tonygo.NetworkMonitorAgent")

        do {
            try service.register()
            print("Successfully registered \(service)")
        } catch {
            print("Unable to register \(error)")
            exit(1)
        }
        
        // Initialize the XPC connection with the service's name
        connection = NSXPCConnection(machServiceName: MACH_SERVICE_NAME)
        connection.remoteObjectInterface = NSXPCInterface(with: NetworkMonitorXPCProtocol.self)
        connection.resume()
    }


    func getNetworkStatus(reply: @escaping (Bool) -> Void) {
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print("Received XPC error:", error)
        } as? NetworkMonitorXPCProtocol

        service?.getNetworkStatus { status in
            reply(status)
        }
    }

    deinit {
        // Invalidate the connection when the client is deinitialized
        connection.invalidate()
    }
}


struct ContentView: View {
    @State private var networkStatus: String = "Off"
    
    private var xpc = NetworkMonitorXPCClient()
    
    
    var body: some View {
        Text("Network status: \(networkStatus)")
            .onAppear {
                xpc.getNetworkStatus { status in
                    DispatchQueue.main.async {
                        self.networkStatus = status ? "Online" : "Offline"
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
