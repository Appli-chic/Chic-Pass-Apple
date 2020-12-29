//
// Created by Lazyos on 29/12/2020.
//

extension StringProtocol {
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }

    var lastUppercased: String {
        prefix(count-1) + suffix(1).uppercased()
    }
}

extension String {
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }

    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}