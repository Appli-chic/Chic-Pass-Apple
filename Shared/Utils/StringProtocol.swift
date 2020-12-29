//
// Created by Lazyos on 29/12/2020.
//

extension StringProtocol {
    var firstUppercased: String {
        prefix(1).uppercased() + dropFirst()
    }
}