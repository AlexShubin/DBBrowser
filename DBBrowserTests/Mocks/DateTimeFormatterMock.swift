//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class DateTimeFormatterMock: DateTimeFormatter {
    func string(from date: Date, style: DateTimeFormatterStyle) -> String {
        inputDate = date
        inputStyle = style
        invocations.append(#function)
        return expectedString
    }

    func date(from string: String, style: DateTimeFormatterStyle) -> Date {
        inputString = string
        inputStyle = style
        invocations.append(#function)
        return expectedDate
    }

    var invocations = [String]()

    var inputDate: Date?
    var inputString: String?
    var inputStyle: DateTimeFormatterStyle?

    var expectedDate = Date()
    var expectedString = ""
}
