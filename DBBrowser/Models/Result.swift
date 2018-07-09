//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

public enum Result<T, E> {
    case success(T)
    case error(E)
}

extension Result: Equatable where T: Equatable, E: Equatable {
    public static func == (lhs: Result, rhs: Result) -> Bool {
        switch (lhs, rhs) {
        case (.success(let lhs), .success(let rhs)):
            return lhs == rhs
        case (.error(let lhs), .error(let rhs)):
            return lhs == rhs
        default:
            return false
        }
    }
}
