import Combine
import Foundation

/// @mockable
public protocol RouterTreeDescriptorWorking: Working {
    var routerTreeNodeDescription: AnyPublisher<String, Never> { get }
}

public final class RouterTreeDescriptorWorker: Worker, RouterTreeDescriptorWorking {
    public var routerTreeNodeDescription: AnyPublisher<String, Never> {
        routerTreeNodeDescriptionSubject.removeDuplicates().compactMap { $0 }.eraseToAnyPublisher()
    }

    private let routerTreeNodeDescriptionSubject = CurrentValueSubject<String?, Never>(nil)

    private var mappingIdentifiersSubject = CurrentValueSubject<[String: Bool], Never>([:])
    private var relevantNodesSubject: CurrentValueSubject<[ChildNode], Never>!

    private var launchRouting: LaunchRouting
    private var cancelables = Set<AnyCancellable>()

    public init(launchRouting: LaunchRouting) {
        self.launchRouting = launchRouting
    }

    override public func didStart(_: InteractorScope) {
        launchRouting.routerTreeDidChange
            .sink {
                self.startTracking()
            }
            .cancelOnStop(self)
    }

    private func startTracking() {
        cancelables.removeAll()
        resetTrackingRelevantNodeSubject()
        mappingIdentifiersSubject
            .sink { identifiers in
                guard !identifiers.isEmpty, !identifiers.values.contains(false) else { return }
                self.relevantNodesSubject.send(completion: .finished)
            }
            .store(in: &cancelables)
        startMappingFrom(ChildNode(router: launchRouting, attachingType: .viewless))
    }

    private func describeTrackingMap(nodes: [ChildNode]) {
        descriptionsFromRelevantNodes(nodes: nodes)
            .compactMap { $0 }
            .forEach {
                routerTreeNodeDescriptionSubject.value = $0
            }
    }

    private func startMappingFrom(_ node: ChildNode) {
        sendNewRelevantNode(node: node, shouldRemoveAllNodes: true)
        buildMap(children: node.router.children)
    }

    private func buildMap(children: [ChildNode]) {
        // This filter will exist till the migration is done
        let children = children.filter { !$0.attachingType.hasSameCaseAs(._none) }

        let cycleIdentifier = UUID().uuidString
        mappingIdentifiersSubject.value[cycleIdentifier] = false

        children
            .sorted(by: { $0.priority < $1.priority })
            .forEach { child in
                switch child.attachingType {
                case .presented, .pushed, .embedded, .mapTop, .mapBottomSheet, .modal:
                    sendNewRelevantNode(node: child, shouldRemoveAllNodes: true)
                    fallthrough
                case .viewless:
                    buildMap(children: child.router.children)
                case let .tab(isActive):
                    isActive.sink { flag in
                        if flag {
                            if !self.mappingIdentifiersSubject.value.isEmpty, !self.mappingIdentifiersSubject.value.values.contains(false) {
                                self.routerTreeNodeDescriptionSubject.value = nil
                            }
                            self.startMappingFrom(child)
                        }
                    }.store(in: &cancelables)
                case ._none:
                    fatalError("fatalError: router \(child.self) not attached correctly")
                }
            }

        mappingIdentifiersSubject.value[cycleIdentifier] = true
    }

    private func sendNewRelevantNode(node: ChildNode, shouldRemoveAllNodes: Bool) {
        var mappedNodes = shouldRemoveAllNodes ? [] : relevantNodesSubject.value
        mappedNodes.append(node)
        relevantNodesSubject.send(mappedNodes)
    }

    private func descriptionsFromRelevantNodes(nodes: [ChildNode]) -> [String?] {
        var descriptions = [String?]()
        nodes
            .sorted {
                $0.priority > $1.priority
            }
            .forEach { child in
                switch child.attachingType {
                /// We need to track only the core rib and excluding all the ribs which are attaching as
                /// `embedded`, `mapBottomSheet`, & `.mapTop` inside the main rib, to avoid sending multiple screen events per screen.
                case .embedded, .mapBottomSheet, .mapTop:
                    return
                case .presented, .pushed, .tab, .viewless:
                    descriptions.removeAll()
                    fallthrough
                case .modal:
                    descriptions.append(child.router.trackingDescription)
                case ._none:
                    fatalError("fatalError: router \(child.self) not attached correctly")
                }
            }
        return descriptions
    }

    private func resetTrackingRelevantNodeSubject() {
        relevantNodesSubject = CurrentValueSubject<[ChildNode], Never>([])
        relevantNodesSubject
            .last()
            .sink { _ in
                self.describeTrackingMap(nodes: self.relevantNodesSubject.value)
                self.resetTrackingRelevantNodeSubject()
            } receiveValue: { _ in
            }.store(in: &cancelables)
    }
}
