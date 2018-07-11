//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol DateTimeFormatter {
    func date(from string: String, style: DateTimeFormatterStyle) -> Date
    func string(from date: Date, style: DateTimeFormatterStyle) -> String
}

enum DateTimeFormatterStyle: String {
    case timetablesApiDateTime = "YYMMddHHmm"
    case timetablesApiDate = "YYMMdd"
    case timetablesApiTime = "HH"
}

struct AppDateTimeFormatter: DateTimeFormatter {
    private let _formatter = DateFormatter()

    public init() {}

    func date(from string: String, style: DateTimeFormatterStyle) -> Date {
        _formatter.dateFormat = style.rawValue
        return _formatter.date(from: string)!
    }

    func string(from date: Date, style: DateTimeFormatterStyle) -> String {
        _formatter.dateFormat = style.rawValue
        return _formatter.string(from: date)
    }
}
