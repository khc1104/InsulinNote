//
//  Item.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/15/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
