import Downer

extension Document {
    public init?(_ description: String, convertHTML: Bool) {
        var description: String = description
        if convertHTML {
            for conversion in HTML.Conversion.allCases {
                description = (try? conversion.convert(description)) ?? description
            }
        }
        self.init(description)
    }
}
