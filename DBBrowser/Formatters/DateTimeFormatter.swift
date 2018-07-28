//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol DateTimeFormatter {
    func date(from string: String, style: DateTimeFormatterStyle) -> Date
    func string(from date: Date, style: DateTimeFormatterStyle) -> String
}

enum DateTimeFormatterStyle: String {
    case apiTimetablesDateTime = "YYMMddHHmm"
    case apiTimetablesDate = "YYMMdd"
    case apiTimetablesTime = "HH"
    case userTimetableTime = "HH:mm"
    case userTimetableDate = "dd MMM"
    case userMainScreenDateTime = "dd MMM, HH:mm"
}

struct AppDateTimeFormatter: DateTimeFormatter {
    private let _timeZone = TimeZone.CEST
    private let _formatter: DateFormatter
    private let _dateLock = NSLock()
    private let _stringLock = NSLock()

    public init() {
        _formatter = DateFormatter()
        _formatter.timeZone = _timeZone
    }

    func date(from string: String, style: DateTimeFormatterStyle) -> Date {
        defer { _dateLock.unlock() }
        _dateLock.lock()
        _formatter.dateFormat = style.rawValue
        return _formatter.date(from: string)!
    }

    func string(from date: Date, style: DateTimeFormatterStyle) -> String {
        defer { _stringLock.unlock() }
        _stringLock.lock()
        _formatter.dateFormat = style.rawValue
        return _formatter.string(from: date)
    }
}
