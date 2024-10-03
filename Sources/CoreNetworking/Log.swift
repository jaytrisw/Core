import Foundation
import CoreLogging

extension Loggable {
    func log(
        _ message: CoreLogging.ContentRepresentable,
        level: CoreLogging.Level,
        category: CoreLogging.Category) {
            log(
                message,
                level: level,
                component: .networkService,
                category: category)
        }
}

public extension CoreLogging.Component {
    static let networkService: Component = "NetworkService"
}
