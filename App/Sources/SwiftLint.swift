import Foundation

struct SwiftLint {
    func directReturn() -> Int {
        let a = 1
        return a
    }

    // swiftlint:disable:next force_cast
    func forceCast() {
        let noWarning = NSNumber() as! Int
        let hasWarning = NSNumber() as! Int
    }
    
    // Enabled by default, disabled by configuration.
    func cyclomaticComplexity() {
        if true {
            if true {
                if false {}
            }
        }
        if false {}
        let i = 0
        switch i {
            case 1: break
            case 2: break
            case 3: break
            case 4: break
            default: break
        }
        for _ in 1...5 {
            guard true else {
                return
            }
        }
    }
}
