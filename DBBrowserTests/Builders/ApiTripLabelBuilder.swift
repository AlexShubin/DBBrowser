//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser

final class ApiTripLabelBuilder {
    private var _category = TestData.Timetable.category1
    private var _number = TestData.Timetable.number1

    func with(category: String) -> ApiTripLabelBuilder {
        _category = category
        return self
    }

    func with(number: String) -> ApiTripLabelBuilder {
        _number = number
        return self
    }

    func build() -> ApiTripLabel {
        return .init(category: _category, number: _number)
    }
}
