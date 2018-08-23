//
//  ChangesLoader.swift
//  DBBrowser
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

typealias ChangesLoaderResult = Result<Changes, ChangesLoaderError>

protocol ChangesLoader {
    func load(evaId: Int) -> Observable<ChangesLoaderResult>
}

enum ChangesLoaderError: String, Error, Equatable {
    case unknown
}

struct ApiChangesLoader: ChangesLoader {
    private let _timetableService: TimetablesService
    private let _changesConverter: ChangesConverter
    private let _dateFormatter: DateTimeFormatter

    init(timetableService: TimetablesService,
         changesConverter: ChangesConverter,
         dateFormatter: DateTimeFormatter) {
        _timetableService = timetableService
        _changesConverter = changesConverter
        _dateFormatter = dateFormatter
    }

    func load(evaId: Int) -> Observable<ChangesLoaderResult> {
        return _timetableService.loadChanges(evaNo: evaId).map {
            .success(self._changesConverter.convert(from: $0))
            }
            .catchError { _ in
                .just(.error(.unknown))
        }
    }
}
