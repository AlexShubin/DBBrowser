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
    func load(evaId: Int, metaEvaIds: Set<Int>, date: Date, corrStation: Station?) -> Observable<Timetable> {
        invocations.append(.load(evaId: evaId, metaEvaIds: metaEvaIds, date: date, corrStation: corrStation))
        return expected
    }

    enum Invocation: Equatable {
        case load(evaId: Int, metaEvaIds: Set<Int>, date: Date, corrStation: Station?)
    }

    var invocations = [Invocation]()
    var expected = Observable.just(Timetable.empty)
}
