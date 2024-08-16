//
//  NetworkMonitor.swift
//  GitHubUsersListTest
//
//  Created by Tony Peng on 2024/8/16.
//

import Network
import SwiftUI

class NetworkMonitor: ObservableObject {
    @Published var isConnected: Bool = true
    private var monitor: NWPathMonitor
    private let queue = DispatchQueue.global(qos: .background)
    
    init() {
        monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
