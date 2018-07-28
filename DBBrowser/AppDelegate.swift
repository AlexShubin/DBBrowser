//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appStateStore: StateStore!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        _setupNavBar()

        let dateFormatter = AppDateTimeFormatter()
        let timetableViewStateConverter = TimetableViewStateConverter(dateFormatter: dateFormatter)
        let mainScreenViewStateConverter = MainScreenViewStateConverter(dateFormatter: dateFormatter)
        let vcFactory = ViewControllerFactory(stationSearchViewStateConverter: StationSearchViewStateConverter(),
                                              mainScreenViewStateConverter: mainScreenViewStateConverter,
                                              timetableViewStateConverter: timetableViewStateConverter)
        let coordinator: SceneCoordinatorType = SceneCoordinator(window: window!, viewControllerFactory: vcFactory)

        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer 276098a8e6050448131e70eab83cae6a"]
        let fahrplanUrl = URL(string: "https://api.deutschebahn.com/fahrplan-plus/v1")!
        let timetablesUrl = URL(string: "https://api.deutschebahn.com/timetables/v1")!
        let fahrplanService = ApiFahrplanService(baseUrl: fahrplanUrl,
                                                 configuration: configuration)
        let timetableService = ApiTimetableService(baseUrl: timetablesUrl,
                                                   configuration: configuration)

        let timetableLoader = ApiTimetableLoader(timetableService: timetableService,
                                                 timetableConverter: TimetableConverter(dateFormatter: dateFormatter),
                                                 dateFormatter: dateFormatter)
        let stationFinder = ApiStationFinder(fahrplanService: fahrplanService,
                                             stationConverter: StationConverter())
        let sideEffects = AppSideEffects(coordinator: coordinator,
                                         stationFinder: stationFinder,
                                         timetableLoader: timetableLoader)
        appStateStore = AppStateStore(sideEffects: sideEffects)
        vcFactory.setUp(appStateStore: appStateStore)
        coordinator.setRoot(scene: .mainScreen)
        return true
    }

    private func _setupNavBar() {
        let navBar = UINavigationBar.appearance()
        navBar.tintColor = UIColor(asset: Asset.Colors.dbRed)
    }
}
