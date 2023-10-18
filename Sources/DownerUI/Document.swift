import Downer

extension Document {
    static func convertHTML(_ description: String) -> String {
        return description
    }
    
    init?(_ description: String, convertHTML: Bool) {
        self.init(convertHTML ? Self.convertHTML(description) : description)
    }
}
