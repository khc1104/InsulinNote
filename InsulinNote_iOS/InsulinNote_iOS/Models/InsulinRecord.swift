//
//  InsulinRecord.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData


@Model
class InsulinRecord{
    @Attribute(.unique) var id: Int
    var insulin: String
    var administion: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(id: Int, insulin: String, administion: Int, createdAt: Date, updatedAt: Date) {
        self.id = id
        self.insulin = insulin
        self.administion = administion
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
