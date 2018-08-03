//
//  TestData.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 13/05/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

//swiftlint:disable line_length
enum TestData {
    static let stationName1 = "Munchen Hbf"
    static let stationId1 = 123
    static let stationName2 = "Nurnberg Hbf"
    static let stationId2 = 321
    static let date1 = Date.testSample(from: "1807071000")

    enum Timetable {
        static let id1 = "3207621895872414763-1807072151-1"
        static let category1 = "ICE"
        static let number1 = "691"
        static let platform1 = "18"
        static let timeString1 = "1807072130"
        static let time1 = Date.testSample(from: timeString1)
        static let stations1 = "Berlin Hbf (tief)|Berlin Südkreuz|Lutherstadt Wittenberg Hbf|Leipzig Hbf|Erfurt Hbf|Eisenach|Fulda|Frankfurt(Main)Hbf|Mannheim Hbf|Stuttgart Hbf|Ulm Hbf|Augsburg Hbf|München-Pasing"

        static let id2 = "-381142949737100268-1807072144-1"
        static let category2 = "RE"
        static let number2 = "1718"
        static let platform2 = "15"
        static let timeString2 = "1807072151"
        static let time2 = Date.testSample(from: timeString2)
        static let stations2 = "Augsburg Hbf|Günzburg|Ulm Hbf|Stuttgart Hbf|Mannheim Hbf|Frankfurt(M) Flughafen Fernbf|Frankfurt(Main)Hbf|Eisenach|Gotha|Erfurt Hbf|Halle(Saale)Hbf|Bitterfeld|Berlin Südkreuz|Berlin Hbf (tief)"
    }
}

private extension Date {
    static func testSample(from str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYMMddHHmm"
        return formatter.date(from: str)!
    }
}
