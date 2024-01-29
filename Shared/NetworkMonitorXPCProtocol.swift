//
//  NetworkMonitorProtocol.swift
//  NetworkMonitor
//
//  Created by Tony Gorez on 25/01/2024.
//

import Foundation

@objc protocol NetworkMonitorXPCProtocol {
    func getNetworkStatus(reply: @escaping (Bool) -> Void)
}
