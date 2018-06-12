//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var appStateStore: StateStore!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let vcFactory = ViewControllerFactory(stationSearchViewStateConverter: StationSearchViewStateConverter(),
                                              mainScreenViewStateConverter: MainScreenViewStateConverter())
        let coordinator = SceneCoordinator(window: window!, viewControllerFactory: vcFactory)
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer 276098a8e6050448131e70eab83cae6a"]
        let url = URL(string: "https://api.deutschebahn.com/fahrplan-plus/v1")!
        let fahrplanService = ApiFahrplanService(baseUrl: url,
                                                 configuration: configuration)
        
        let stationFinder = ApiStationFinder(fahrplanService: fahrplanService,
                                             stationConverter: ApiStationConverter())
        
        let sideEffects = AppSideEffects(coordinator: coordinator,
                                         stationFinder: stationFinder)
        appStateStore = AppStateStore(sideEffects: sideEffects)
        vcFactory.setUp(appStateStore: appStateStore)
        coordinator.transition(to: .mainScreen, type: .root)
        return true
    }
}

