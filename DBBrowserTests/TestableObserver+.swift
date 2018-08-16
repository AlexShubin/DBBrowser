//
//  TestableObserver+.swift
//  DBBrowserTests
//
//  Created by Alex Shubin on 13/05/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxTest

extension TestableObserver {
    var firstElement: ElementType? {
        return events.first?.value.element
    }
}
