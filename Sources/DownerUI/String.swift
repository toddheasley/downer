import Foundation

extension String {
    func replacingSubstrings(matching pattern: Self, with template: Self) throws -> Self {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: [
            .caseInsensitive,
            .dotMatchesLineSeparators
        ])
        return regex.stringByReplacingMatches(in: self, range: NSMakeRange(0, count), withTemplate: template)
    }
    
    func replacingSubstrings(matching pattern: Self, with modifier: (Self) -> Self) throws -> Self {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: [
            .caseInsensitive,
            .dotMatchesLineSeparators
        ])
        var string: String = self
        let matches: [NSTextCheckingResult] = regex.matches(in: string, range: NSMakeRange(0, string.count))
        for match in matches.reversed() {
            guard let range: Range<Index> = Range(match.range, in: string) else {
                continue
            }
            let substring: Self = "\(string[range.lowerBound..<range.upperBound])"
            string = string.replacingCharacters(in: range, with: modifier(substring))
        }
        return string
    }
    
    func substrings(matching pattern: Self) throws -> [Self] {
        let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: [
            .caseInsensitive,
            .dotMatchesLineSeparators
        ])
        return regex.matches(in: self, range: NSMakeRange(0, count)).compactMap { match in
            guard let range: Range<Index> = Range(match.range, in: self) else {
                return nil
            }
            return "\(self[range.lowerBound..<range.upperBound])"
        }
    }
}
