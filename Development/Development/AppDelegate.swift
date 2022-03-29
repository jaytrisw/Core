//
//  AppDelegate.swift
//  Development
//
//  Created by Joshua Wood on 2/14/22.
//

import UIKit
import Core

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let networkMonitor = NetworkMonitor.main
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //        UIViewController.swizzle()
        //        self.networkMonitor.startMonitoring()
        
        return true
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
    
    
}

extension UIViewController {
    
    @objc
    func viewDidLoadOverride() {
        self.viewDidLoadOverride() //Incase we need to override this method
        
    }
    
    static func swizzle() {
        //Make sure This isn't a subclass of UIViewController, So that It applies to all UIViewController childs
        guard self == UIViewController.self else {
            return
        }
        let originalSelector = #selector(UIViewController.viewDidLoad)
        let swizzledSelector = #selector(UIViewController.viewDidLoadOverride)
        guard let originalMethod = class_getInstanceMethod(self, originalSelector),
              let swizzledMethod = class_getInstanceMethod(self, swizzledSelector) else { return }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
    
}

import Network
import Log

public enum NetworkType {
    case wifi
    case cellular
    case wiredEthernet
    case lowData
    case personalHotspot
    case none
}

final class NetworkMonitor {
    
    private let pathMonitor: NWPathMonitor
    private let queue: DispatchQueue
    private var currentNetworkType: NetworkType {
        didSet {
            Log(self.currentNetworkType, level: .debug)
        }
    }
    
    static var main: NetworkMonitor {
        return .init()
    }
    
    private init() {
        self.pathMonitor = NWPathMonitor()
        self.queue = DispatchQueue(label: "NetworkMonitor")
        self.currentNetworkType = .none
    }
    
}

extension NetworkMonitor: Monitorable {
    
    func startMonitoring() {
        self.pathMonitor.start(queue: self.queue)
        self.pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let networkType = self?.getConnectionType(path) else {
                self?.currentNetworkType = .none
                return
            }
            self?.currentNetworkType = networkType
        }
    }
    
    func stopMonitoring() {
        self.pathMonitor.cancel()
    }
    
    func getConnectionType(_ path: NWPath) -> NetworkType {
        guard path.isConstrained == false else {
            return .lowData
        }
        guard path.isExpensive == false else {
            if path.usesInterfaceType(.cellular) {
                return .cellular
            } else {
                return .personalHotspot
            }
        }
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .wiredEthernet
        } else {
            return .none
        }
    }
    
}

@propertyWrapper
struct SomeThread<Input> {
    
    let queue: DispatchQueue
    var closure: ((Input) -> Void)?
    
    var wrappedValue: ((_ newValue: Input) -> Void)? {
        get {
            return { newValue in
                self.queue.async {
                    Log.critical(newValue)
                    self.closure?(newValue)
                }
            }
        }
        
        set {
            self.closure = newValue
        }
    }
    
    public init(wrappedValue: ((Input) -> Void)?, queue: DispatchQueue) {
        self.queue = queue
        self.closure = wrappedValue
    }
    
}

import Combine
import CoreData

extension NSManagedObjectContext {
    
    public func fetchedResultsPublisher<Entity: NSManagedObject>(
        fetchRequest: NSFetchRequest<Entity>) -> FetchedResultsPublisher<Entity> {
            return FetchedResultsPublisher(self, fetchRequest: fetchRequest)
        }
    
    public struct FetchedResultsPublisher<Entity: NSManagedObject>: Publisher {
        
        // MARK: Properties
        private let managedObjectContext: NSManagedObjectContext
        private let fetchRequest: NSFetchRequest<Entity>
        
        // MARK: Life Cycle
        public init(
            _ managedObjectContext: NSManagedObjectContext,
            fetchRequest: NSFetchRequest<Entity>) {
                self.managedObjectContext = managedObjectContext
                self.fetchRequest = fetchRequest
            }
        
        // MARK: Publisher
        public func receive<S>(subscriber: S) where S: Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = FetchedResultsSubscription(
                subscriber: subscriber,
                managedObjectContext: self.managedObjectContext,
                fetchRequest: self.fetchRequest)
            
            subscriber.receive(subscription: subscription)
        }
        
        public typealias Output = [Entity]
        public typealias Failure = Swift.Error
        
    }
    
    typealias FetchedResultsDelegate = NSObject & NSFetchedResultsControllerDelegate
    internal class FetchedResultsSubscription<S: Subscriber, Entity: NSManagedObject>: FetchedResultsDelegate where S.Input == [Entity], S.Failure == Swift.Error {
        
        // MARK: Properties
        private var subscriber: S?
        private var fetchRequest: NSFetchRequest<Entity>
        private var managedObjectContext: NSManagedObjectContext
        private var fetchedResultsController: NSFetchedResultsController<Entity>
        
        // MARK: Life Cycle
        internal init(
            subscriber: S,
            managedObjectContext: NSManagedObjectContext,
            fetchRequest: NSFetchRequest<Entity>) {
                self.subscriber = subscriber
                self.managedObjectContext = managedObjectContext
                self.fetchRequest = fetchRequest
                self.fetchedResultsController = NSFetchedResultsController(
                    fetchRequest: fetchRequest,
                    managedObjectContext: managedObjectContext,
                    sectionNameKeyPath: nil,
                    cacheName: fetchRequest.entityName)
                
            }
        
        // MARK: NSFetchedResultsControllerDelegate
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard let items = controller.fetchedObjects as? [Entity] else {
                _ = self.subscriber?.receive([])
                return
            }
            _ = self.subscriber?.receive(items)
        }
        
    }
    
}

extension NSManagedObjectContext.FetchedResultsSubscription: Subscription {
    
    internal func request(_ demand: Subscribers.Demand) {
        guard demand > 0 else {
            return
        }
        do {
            self.fetchedResultsController.delegate = self
            try fetchedResultsController.performFetch()
            
            let items = try self.managedObjectContext.fetch(self.fetchRequest)
            _ = self.subscriber?.receive(items)
        } catch {
            _ = self.subscriber?.receive(completion: .failure(error))
        }
    }
    
}

extension NSManagedObjectContext.FetchedResultsSubscription: Cancellable {
    
    internal func cancel() {
        self.subscriber = nil
    }
    
}
