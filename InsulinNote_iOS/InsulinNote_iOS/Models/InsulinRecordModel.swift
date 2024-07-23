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
    @Attribute(.unique) var id: Int
    var insulin: DefaultInsulinModel
    var administion: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(id: Int, insulin: DefaultInsulinModel, administion: Int, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.insulin = insulin
        self.administion = administion
        self.createdAt = .now
        self.updatedAt = updatedAt
    }
}
