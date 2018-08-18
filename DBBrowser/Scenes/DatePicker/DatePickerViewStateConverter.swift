//
//  Copyright © 2018 AlexShubin. All rights reserved.
//

struct DatePickerViewStateConverter: ViewStateConverter {
    func convert(from state: TimetableState) -> DatePickerViewState {
        return DatePickerViewState(date: state.date)
    }
}
