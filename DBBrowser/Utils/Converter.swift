//
//  Converter.swift
//  DBBrowser
//
//  Created by Alex Shubin on 08/07/2018.
//  Copyright © 2018 AlexShubin. All rights reserved.
//

public protocol Converter {
    associatedtype Input
    associatedtype Output
    func convert(from input: Input) -> Output
}
