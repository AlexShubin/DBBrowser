//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

import RxTest
import RxSwift

extension RxTest.Recorded: Equatable where Value: Equatable {}
extension RxSwift.Event: Equatable where Element: Equatable {}
