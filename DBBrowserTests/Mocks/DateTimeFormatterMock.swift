//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import Foundation

final class DateTimeFormatterMock: DateTimeFormatter {
    func date(from string: String, style: DateTimeFormatterStyle) -> Date {
        return expectedDate
    }

    var expectedDate = Date()
}