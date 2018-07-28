//
//  ViewStateConverter.swift
//  DBBrowser
//
//  Created by Alex Shubin on 08/07/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

public protocol ViewStateConverter {
    associatedtype State
    associatedtype ViewState
    func convert(from state: State) -> ViewState
}
