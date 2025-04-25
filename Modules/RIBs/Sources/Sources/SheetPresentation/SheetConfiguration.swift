import UIKit

/// This configuration maps to properties on ``UISheetPresentationController``.
public struct SheetConfiguration {
    /// A Boolean value that determines whether the sheet shows a grabber at the top.
    ///
    /// Set this value to `true` for the system to draw a grabber in the standard system-defined location.
    /// The system automatically hides the grabber at appropriate times, like when the sheet is full screen in a
    /// compact-height size class or when another sheet presents on top of it.
    ///
    /// The default value is `false`, which means the sheet doesn’t show a grabber.
    public let prefersGrabberVisible: Bool

    /// The array of heights where a sheet can rest.
    ///
    /// This array must contain at least one element. When you set this value, specify detents in order from smallest
    /// to largest height.
    ///
    /// The default value is an array that contains the value ``medium()``.
    public let detents: [UISheetPresentationController.Detent]

    /// The identifier of the most recently selected detent.
    ///
    /// This property represents the most recent detent that the user selects or that you set programmatically.
    /// When the value is `nil` or the identifier is not found in detents, the sheet displays at the smallest detent
    /// you specify in ``detents``.
    ///
    /// The default value is `nil`
    public let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?

    /// The largest detent that doesn’t dim the view underneath the sheet.
    ///
    /// Set this property to only add the dimming view at detents larger than the detent you specify. For example,
    /// set this property to ``medium`` to add the dimming view at the ``large`` detent.
    /// Without a dimming view, the undimmed area around the sheet responds to user interaction, allowing for a
    /// nonmodal experience. You can use this behavior for sheets with interactive content underneath them.
    ///
    /// The default value is `nil`, which means the system adds a noninteractive dimming view underneath the sheet at all detents.
    public let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?

    /// A Boolean value that determines whether scrolling expands the sheet to a larger detent.
    ///
    /// When `true`, the sheet can expand to a larger detent than ``selectedDetentIdentifier``, scrolling up in the sheet increases its detent instead of scrolling the sheet’s content. After the sheet reaches its largest detent, scrolling begins.
    ///
    /// Set this value to `false` if you want to avoid letting a scroll gesture expand the sheet. For example,
    /// you can set this value on a nonmodal sheet to avoid obscuring the content underneath the sheet.
    ///
    /// The default value is `true`.
    public let prefersScrollingExpandsWhenScrolledToEdge: Bool

    /// The corner radius that the sheet attempts to present with.
    ///
    /// This property only has an effect when the sheet is at the front of its sheet stack.
    ///
    /// The default value is `nil`.
    public let preferredCornerRadius: CGFloat?

    public init(
        prefersGrabberVisible: Bool = false,
        detents: [UISheetPresentationController.Detent] = [.medium()],
        selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
        prefersScrollingExpandsWhenScrolledToEdge: Bool = true,
        preferredCornerRadius: CGFloat? = nil
    ) {
        self.prefersGrabberVisible = prefersGrabberVisible
        self.detents = detents
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.preferredCornerRadius = preferredCornerRadius
    }
}

extension SheetConfiguration {
    public static let `default` = SheetConfiguration()
}
