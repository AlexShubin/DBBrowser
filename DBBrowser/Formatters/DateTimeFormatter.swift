//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import Foundation

protocol DateTimeFormatter {
    func date(from string: String, style: DateTimeFormatterStyle) -> Date
}

enum DateTimeFormatterStyle: String {
    case timetablesApi = "YYMMddHHmm"
}

struct AppDateTimeFormatter: DateTimeFormatter {
    private let _formatter = DateFormatter()

    public init() {}

    func date(from string: String, style: DateTimeFormatterStyle) -> Date {
        _formatter.dateFormat = style.rawValue
        return _formatter.date(from: string)!
    }
}
