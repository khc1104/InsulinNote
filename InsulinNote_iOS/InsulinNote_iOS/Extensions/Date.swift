//
//  Date.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 5/19/25.
//

import Foundation

extension Date: @retroactive Identifiable {
    public var id: TimeInterval {
        self.timeIntervalSince1970
    }
}
