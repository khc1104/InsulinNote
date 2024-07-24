//
//  InsulinRecord.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData


@Model
class InsulinRecordModel{
    @Attribute(.unique) var id: UUID = UUID()
    var insulin: DefaultInsulinModel
    var administion: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(insulin: DefaultInsulinModel, administion: Int, createdAt: Date, updatedAt: Date) {
        self.insulin = insulin
        self.administion = administion
        self.createdAt = .now
        self.updatedAt = updatedAt
    }
}
