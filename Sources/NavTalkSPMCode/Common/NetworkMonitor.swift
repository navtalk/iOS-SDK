import Network
import Foundation

class NetworkMonitor: @unchecked Sendable {
    static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    func start() {
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    NotificationCenter.default.post(name: .didGainNetwork, object: nil)
                } else {
                    NotificationCenter.default.post(name: .didLoseNetwork, object: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }
}

extension Notification.Name : @unchecked Sendable {
    static let didGainNetwork = Notification.Name("didGainNetwork")
    static let didLoseNetwork = Notification.Name("didLoseNetwork")
}
