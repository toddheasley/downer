typealias HTML = String

extension HTML {
    var escaped: Self {
        var string: Self = self
        for escape in [("&", "&amp;"), ("<", "&lt;"), (">", "&gt;")] {
            string = string.replacingOccurrences(of: escape.0, with: escape.1)
        }
        return string
    }
}
