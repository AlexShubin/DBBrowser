//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
import XCTest

class StringExtensionsTests: XCTestCase {

    func givenStringContainsTheOther() {
        XCTAssertTrue("123456789".interrelated(to: "456"))
    }

    func OtherStringContainsAGivenString() {
        XCTAssertTrue("456".interrelated(to: "123456789"))
    }
}
