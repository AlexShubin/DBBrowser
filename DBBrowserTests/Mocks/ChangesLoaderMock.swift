//
//  ChangesLoaderMock.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 23/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation
import RxSwift

class ChangesLoaderMock: ChangesLoader {
    func load(evaId: Int) -> Observable<ChangesLoaderResult> {
        invocations.append(.load(evaId: evaId))
        return expected
    }

    enum Invocation: Equatable {
        case load(evaId: Int)
    }

    var invocations = [Invocation]()
    var expected = Observable.just(ChangesLoaderResult.success(ChangesBuilder().build()))
}
