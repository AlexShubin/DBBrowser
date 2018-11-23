//
//  ChangesConverterMock.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 21/08/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

@testable import DBBrowser
@testable import DBAPI

class ChangesConverterMock: ChangesConverter {
    func convert(from apiChanges: ApiChanges) -> Changes {
        return expected
    }

    var expected = ChangesBuilder().build()
}
