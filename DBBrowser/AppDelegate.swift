//
//  AppDelegate.swift
//  DBBrowser
//
//  Created by Alex Shubin on 11/05/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import UIKit
import Apollo

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "Bearer 276098a8e6050448131e70eab83cae6a"]
        let url = URL(string: "https://api.deutschebahn.com/free1bahnql/v1/graphql")!
        let apollo = ApolloClient(networkTransport: HTTPNetworkTransport(url: url, configuration: configuration))
        
        apollo.fetch(query: SearchStationQuery(namePart: "mun"),
                     cachePolicy: .returnCacheDataElseFetch,
                     queue: DispatchQueue.main) { (result, error) in
                        result?.data?.search.stations.forEach({
                            print($0.name)
                            print($0.primaryEvaId)
                        })
        }
        
        return true
    }
}

