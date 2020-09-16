import InstantSearchCore
import UIKit

extension UILabel {
    var highlightedText: String? {
        get {
            return attributedText?.string
        }
        set {
            let color = highlightedTextColor ?? self.tintColor ?? UIColor.blue
            attributedText = newValue == nil ? nil : Highlighter(highlightAttrs: [NSForegroundColorAttributeName: color]).render(text: newValue!)
        }
    }
}
