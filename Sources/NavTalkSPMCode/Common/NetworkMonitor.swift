import Network
import Foundation

extension Notification.Name {
    static let didGainNetwork = Notification.Name("didGainNetwork")
    static let didLoseNetwork = Notification.Name("didLoseNetwork")
}

@MainActor
class NetworkMonitor {
    @MainActor static let shared = NetworkMonitor()
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)

    func start() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                Task{@MainActor in
                    NotificationCenter.default.post(name: .didGainNetwork, object: nil)
                }
            } else {
                Task{@MainActor in
                    NotificationCenter.default.post(name: .didLoseNetwork, object: nil)
                }
            }
        }
        monitor.start(queue: queue)
    }
}


