import Combine
import UIKit

/// Leak detection status.
public enum LeakDetectionStatus {
    /// Leak detection is in progress.
    case inProgress

    /// Leak detection has completed.
    case didComplete
}

/// The default time values used for leak detection expectations.
public enum LeakDefaultExpectationTime {
    /// The object deallocation time.
    public static let deallocation = 1.0

    /// The view disappear time.
    public static let viewDisappear = 5.0
}

/// The handle for a scheduled leak detection.
public protocol LeakDetectionHandle {
    /// Cancel the scheduled detection.
    func cancel()
}

/// An expectation based leak detector, that allows an object's owner to set an expectation that an owned object to be
/// deallocated within a time frame.
///
/// A `Router` that owns an `Interactor` might for example expect its `Interactor` be deallocated when the `Router`
/// itself is deallocated. If the interactor does not deallocate in time, a runtime assert is triggered, along with
/// critical logging.
public class LeakDetector {
    private let trackingObjects = NSMapTable<AnyObject, AnyObject>.strongToWeakObjects()
    private let expectationCount = CurrentValueSubject<Int, Never>(0)
    private var expectationCountDisposable: Cancellable?

    lazy var disableLeakDetector: Bool = {
        if let environmentValue = ProcessInfo().environment["DISABLE_LEAK_DETECTION"] {
            let lowercase = environmentValue.lowercased()
            return lowercase == "yes" || lowercase == "true"
        }
        return LeakDetector.disableLeakDetectorOverride
    }()

    // Test override for leak detectors.
    static var disableLeakDetectorOverride: Bool = false

    #if DEBUG
        /// Reset the state of Leak Detector, internal for UI test only.
        func reset() {
            trackingObjects.removeAllObjects()
            expectationCount.value = 0
        }
    #endif

    private init() {
        expectationCountDisposable = expectationCount.sink { [weak self] count in
            self?.status.value = count > 0 ? .inProgress : .didComplete // swiftlint:disable:this empty_count
        }
    }

    /// The singleton instance.
    public static let instance = LeakDetector()

    /// The status of leak detection.
    ///
    /// The status changes between InProgress and DidComplete as units register for new detections, cancel existing
    /// detections, and existing detections complete.
    public var status = CurrentValueSubject<LeakDetectionStatus, Never>(.didComplete)

    /// A publisher that emits a Leak when a leak is detected.
    ///
    /// The Leak contains a message describing the leak.
    public var leaks = PassthroughSubject<Leak, Never>()

    /// Sets up an expectation for the given object to be deallocated within the given time.
    ///
    /// - parameter object: The object to track for deallocation.
    /// - parameter inTime: The time the given object is expected to be deallocated within.
    /// - returns: The handle that can be used to cancel the expectation.
    @discardableResult
    public func expectDeallocate(object: AnyObject, inTime time: TimeInterval = LeakDefaultExpectationTime.deallocation) -> LeakDetectionHandle {
        expectationCount.value += 1

        let objectDescription = String(describing: object)
        let objectId = String(ObjectIdentifier(object).hashValue) as NSString
        trackingObjects.setObject(object, forKey: objectId)

        let handle = LeakDetectionHandleImpl {
            self.expectationCount.value -= 1
        }

//        Executor.execute(withDelay: time) { [weak object] in
//            // Retain the handle so we can check for the cancelled status. Also cannot use the cancellable
//            // concurrency API since the returned handle must be retained to ensure closure is executed.
//            if let object, !handle.cancelled {
//                let didDeallocate = (self.trackingObjects.object(forKey: objectId) == nil)
//                let message = Logger.Message("<\(objectDescription, privacy: .public): \(objectId)> has leaked. Objects are expected to be deallocated at this time: \(self.trackingObjects)")
//
//                if self.disableLeakDetector {
//                    if !didDeallocate {
//                        logger.warning("Leak detection is disabled. This should only be used for debugging purposes.")
//                        logger.warning(message)
//                    }
//                } else if !didDeallocate {
//                    logger.error(message)
//                    self.leaks.send(.objectLeaked(object: object, trackingObjects: self.trackingObjects))
//                    assertionFailure(message.description)
//                }
//            }
//
//            self.expectationCount.value -= 1
//        }

        return handle
    }

    /// Sets up an expectation for the given view controller to disappear within the given time.
    ///
    /// - parameter viewController: The `UIViewController` expected to disappear.
    /// - parameter inTime: The time the given view controller is expected to disappear.
    /// - returns: The handle that can be used to cancel the expectation.
    @discardableResult
    public func expectViewControllerDisappear(viewController: UIViewController, inTime time: TimeInterval = LeakDefaultExpectationTime.viewDisappear) -> LeakDetectionHandle {
        expectationCount.value += 1

        let handle = LeakDetectionHandleImpl {
            self.expectationCount.value -= 1
        }

//        Executor.execute(withDelay: time) { [weak viewController] in
//            // Retain the handle so we can check for the cancelled status. Also cannot use the cancellable
//            // concurrency API since the returned handle must be retained to ensure closure is executed.
//            if let viewController, !handle.cancelled {
//                let viewDidDisappear = (!viewController.isViewLoaded || viewController.view.window == nil)
//                let message = Logger.Message("\(viewController) appearance has leaked. Either its parent router who does not own a view controller was detached, but failed to dismiss the leaked view controller; or the view controller is reused and re-added to window, yet the router is not re-attached but re-created. Objects are expected to be deallocated at this time: \(self.trackingObjects)")
//
//                if self.disableLeakDetector {
//                    if !viewDidDisappear {
//                        logger.notice("Leak detection is disabled. This should only be used for debugging purposes.")
//                        logger.notice(message)
//                    }
//                } else if !viewDidDisappear {
//                    logger.error(message)
//                    self.leaks.send(.viewControllerLeaked(viewController: viewController, trackingObjects: self.trackingObjects))
//                    assertionFailure(message.description)
//                }
//            }
//
//            self.expectationCount.value -= 1
//        }

        return handle
    }
}

private class LeakDetectionHandleImpl: LeakDetectionHandle {
    var cancelled: Bool {
        cancelledVariable.value
    }

    let cancelledVariable = CurrentValueSubject<Bool, Never>(false)
    let cancelClosure: (() -> Void)?

    init(cancelClosure: (() -> Void)? = nil) {
        self.cancelClosure = cancelClosure
    }

    func cancel() {
        cancelledVariable.value = true
        cancelClosure?()
    }
}

/// An enumeration representing different types of leaks.
public enum Leak: Error {
    /// Represents a leaked object.
    case objectLeaked(object: AnyObject, trackingObjects: NSMapTable<AnyObject, AnyObject>)

    /// Represents a leaked view controller.
    case viewControllerLeaked(viewController: UIViewController, trackingObjects: NSMapTable<AnyObject, AnyObject>)
}

extension Leak: LocalizedError {
    public var message: String {
        switch self {
        case let .objectLeaked(object, trackingObjects):
            "\(String(describing: object)) has leaked. Objects are expected to be deallocated at this time: \(trackingObjects)"
        case let .viewControllerLeaked(viewController, trackingObjects):
            "\(String(describing: viewController)) appearance has leaked. Objects are expected to be deallocated at this time: \(trackingObjects)"
        }
    }

    public var errorDescription: String? {
        message
    }
}

extension Leak: CustomNSError {
    public var errorUserInfo: [String: Any] {
        let moduleAndType: String = switch self {
        case let .objectLeaked(object, _):
            String(reflecting: type(of: object))
        case let .viewControllerLeaked(viewController, _):
            String(reflecting: type(of: viewController))
        }

        var userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: message
        ]

        if let module = moduleAndType.trimmed.moduleName {
            userInfo["module"] = module
        }

        if let type = moduleAndType.trimmed.typeName {
            userInfo["leaked_object"] = type
        }

        return userInfo
    }
}

extension String {
    fileprivate var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }

    fileprivate var moduleName: String? {
        guard contains(".") else { return nil }
        return components(separatedBy: ".").first
    }

    fileprivate var typeName: String? {
        guard contains(".") else { return nil }
        return components(separatedBy: ".").last
    }
}
