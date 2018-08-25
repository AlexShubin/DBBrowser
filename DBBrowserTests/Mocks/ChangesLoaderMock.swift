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
    func load(evaId: Int, metaEvaIds: Set<Int>) -> Observable<Changes> {
        invocations.append(.load(evaId: evaId, metaEvaIds: metaEvaIds))
        return expected
    }

    enum Invocation: Equatable {
        case load(evaId: Int, metaEvaIds: Set<Int>)
    }

    var invocations = [Invocation]()
    var expected = Observable.just(ChangesBuilder().build())
}
