//
//  StationInfoLoaderMock.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 24/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation
import RxSwift

class StationInfoLoaderMock: StationInfoLoader {
    func load(evaId: Int) -> Observable<StationInfo> {
        invocations.append(.load(evaId: evaId))
        return expected
    }

    enum Invocation: Equatable {
        case load(evaId: Int)
    }

    var invocations = [Invocation]()
    var expected = Observable.just(StationInfo.empty)
}
