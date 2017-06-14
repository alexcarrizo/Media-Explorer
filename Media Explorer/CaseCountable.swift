//
//  CaseCountable.swift
//  Media Explorer
//
//  Created by Alex Carrizo on 6/6/17.
//  Copyright © 2017 Alex Carrizo. All rights reserved.
//

import Foundation

protocol CaseCountable {
    static func countCases() -> Int
    static var count : Int { get }
}

extension CaseCountable where Self : RawRepresentable, Self.RawValue == Int {
    static func countCases() -> Int {
        var count = 0
        while let _ = Self(rawValue: count) { count += 1 }
        return count
    }
}
