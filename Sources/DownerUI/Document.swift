import Downer

extension Document: Equatable {
    public init?(_ description: String, convertHTML: Bool) {
        var description: String = description
        if convertHTML {
            for conversion in HTML.Conversion.allCases {
                description = (try? conversion.convert(description)) ?? description
            }
        }
        self.init(description)
    }
    
    // MARK: Equatable
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.description == rhs.description
    }
}
