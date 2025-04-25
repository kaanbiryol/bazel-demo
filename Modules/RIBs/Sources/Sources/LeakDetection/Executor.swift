import Foundation

enum Executor {
    /// Execute the given logic after the given delay assuming the given maximum frame duration.
    ///
    /// This allows excluding the time elapsed due to breakpoint pauses.
    ///
    /// - note: The logic closure is not guaranteed to be performed exactly after the given delay. It may be performed
    ///   later if the actual frame duration exceeds the given maximum frame duration.
    ///
    /// - parameter delay: The delay to perform the logic, excluding any potential elapsed time due to breakpoint
    ///   pauses.
    /// - parameter maxFrameDuration: The maximum duration a single frame should take. Defaults to 33ms.
    /// - parameter logic: The closure logic to perform.
    static func execute(withDelay delay: TimeInterval, maxFrameDuration: TimeInterval = 0.033, logic: @escaping () -> Void) {
        let period = maxFrameDuration / 3.0
        var lastRunLoopTime = Date().timeIntervalSinceReferenceDate
        var properFrameTime = 0.0

        let timer = Timer(timeInterval: period, repeats: true) { timer in
            let currentTime = Date().timeIntervalSinceReferenceDate
            let trueElapsedTime = currentTime - lastRunLoopTime
            lastRunLoopTime = currentTime

            // If we did drop frame, we under-count the frame duration, which is fine. It
            // just means the logic is performed slightly later.
            let boundedElapsedTime = min(trueElapsedTime, maxFrameDuration)
            properFrameTime += boundedElapsedTime
            if properFrameTime > delay {
                timer.invalidate()
                logic()
            }
        }
        RunLoop.main.add(timer, forMode: .common)
    }
}
