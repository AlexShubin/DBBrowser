//
//  TimetableLoaderMock.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 23/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation
import RxSwift

class TimetableLoaderMock: TimetableLoader {
    func load(station: Station, date: Date, corrStation: Station?) -> Observable<TimetableLoaderResult> {
        invocations.append(.load(station: station, date: date, corrStation: corrStation))
        return expected
    }

    enum Invocation: Equatable {
        case load(station: Station, date: Date, corrStation: Station?)
    }

    var invocations = [Invocation]()
    var expected = Observable.just(TimetableLoaderResult.success(TimetableBuilder().build()))
}
