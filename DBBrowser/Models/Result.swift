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

// Result - Functor
public extension Result {
    public func map<U>(_ transform: (T) throws -> U) rethrows -> Result<U, E> {
        switch self {
        case .success(let value):
            return .success(try transform(value))
        case .error(let error):
            return .error(error)
        }
    }
}

// Result - Monad
public extension Result {
    public func flatMap<U>(_ transform: (T) throws -> Result<U, E>) rethrows -> Result<U, E> {
        switch self {
        case .success(let value):
            return try transform(value)
        case .error(let error):
            return .error(error)
        }
    }
}

// Result - Error mapping
public extension Result {
    public func mapError<U>(_ transform: (E) throws -> U) rethrows -> Result<T, U> {
        switch self {
        case .success(let value):
            return .success(value)
        case .error(let error):
            return .error(try transform(error))
        }
    }
}

