//
//  Copyright © 2018 tutu.ru. All rights reserved.
//

import RxTest

extension TestableObserver {
    var firstElement: ElementType? {
        return events.first?.value.element
    }
}
