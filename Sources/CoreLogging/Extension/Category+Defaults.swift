import Foundation

public extension Category {
    /// A general-purpose category for logs and events that do not fit into a more specific category.
    ///
    /// Use this category for generic log messages or events that do not have a more defined classification. It serves as a catch-all for miscellaneous logs.
    ///
    /// ```swift
    /// let logger: Loggable = MyLogger()
    /// logger.info("Application started", component: "AppLifecycle", category: .general)
    /// ```
    static let general: Category = "General"

    /// A category used for logs and events related to object deallocation.
    ///
    /// Use this category when logging events that involve the deallocation of objects, such as when tracking resource cleanup or memory management.
    ///
    /// ```swift
    /// let logger: Loggable = MyLogger()
    /// logger.debug("Object deallocated", component: "MemoryManager", category: .deallocated)
    /// ```
    static let deallocated: Category = "Deallocated"
}
