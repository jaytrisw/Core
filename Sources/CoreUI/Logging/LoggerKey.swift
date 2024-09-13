//
//  TrackerKey.swift
//  Core
//
//  Created by Joshua Wood on 9/11/24.
//


import CoreLogging
import SwiftUI

fileprivate struct LoggerKey: EnvironmentKey {
    fileprivate static let defaultValue: Loggable = .default
}

public extension EnvironmentValues {
    var logger: Loggable {
        get { self[LoggerKey.self] }
        set { self[LoggerKey.self] = newValue }
    }
}

public extension View {
    func logger(_ logger: Loggable) -> some View {
        environment(\.logger, logger)
    }
}

import CoreLogging
import SwiftUI

@available(iOS 15.0, *)
public extension View {
    func log(
        _ message: CoreLogging.ContentRepresentable,
        level: CoreLogging.Level = .default,
        component: CoreLogging.Component = "CoreUI",
        category: CoreLogging.Category = .general) -> some View {
            modifier(
                LoggingModifier(
                    message: message,
                    level: level,
                    component: component,
                    category: category))
        }

}

@available(iOS 15.0, *)
fileprivate struct LoggingModifier: ViewModifier {
    @Environment(\.logger) fileprivate var logger
    fileprivate let message: CoreLogging.ContentRepresentable
    fileprivate let level: CoreLogging.Level
    fileprivate let component: CoreLogging.Component
    fileprivate let category: CoreLogging.Category

    fileprivate func body(content: Self.Content) -> some View {
        logger.log(message, level: level, component: component, category: category)

        return content
    }
}

fileprivate struct LoggingWrapper: View {
    @Environment(\.logger) fileprivate var logger
    fileprivate let message: CoreLogging.ContentRepresentable
    fileprivate let level: CoreLogging.Level
    fileprivate let component: CoreLogging.Component
    fileprivate let category: CoreLogging.Category

    fileprivate var body: some View {
        EmptyView()
    }
}
