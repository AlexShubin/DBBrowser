//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxSwift
import Apollo

protocol BahnQLService {
    func searchStation(namePart: String) -> Observable<[SearchStationQuery.Data.Search.Station]>
}

struct ApiBahnQLService: BahnQLService {
    private let _apollo: ApolloClient
    
    init(apollo: ApolloClient) {
        _apollo = apollo
    }
    
    func searchStation(namePart: String) -> Observable<[SearchStationQuery.Data.Search.Station]> {
        return .create { observer in
            let cancellabe = self._apollo
                .fetch(query: SearchStationQuery(namePart: namePart),
                       cachePolicy: .returnCacheDataElseFetch,
                       queue: DispatchQueue.main) { (result, error) in
                        guard let stations = result?.data?.search.stations else {
                            observer.onError(error ?? RxError.unknown)
                            return
                        }
                        observer.onNext(stations)
                        observer.onCompleted()
            }
            return Disposables.create {
                cancellabe.cancel()
            }
        }
    }
}

