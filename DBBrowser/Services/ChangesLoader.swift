//
//  ChangesLoader.swift
//  DBBrowser
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift

protocol ChangesLoader {
    func load(evaId: Int, metaEvaIds: Set<Int>) -> Observable<Changes>
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

    func load(evaId: Int, metaEvaIds: Set<Int>) -> Observable<Changes> {
        var allIds = metaEvaIds
        allIds.insert(evaId)
        return  _apiLoadChanges(evaIds: allIds).map {
            self._changesConverter.convert(from: $0)
        }
    }

    private func _apiLoadChanges(evaIds: Set<Int>) -> Observable<ApiChanges> {
        return Observable.combineLatest(evaIds.map {
            self._timetableService.loadChanges(evaNo: $0)
        }) { $0.reduce(ApiChanges(stops: []), { $0 + $1 }) }
    }
}
