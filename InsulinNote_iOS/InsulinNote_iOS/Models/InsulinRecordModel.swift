//
//  InsulinRecord.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData


@Model
class InsulinRecordModel: Identifiable{
    @Attribute(.unique) var id: UUID = UUID() //id
    
    var administion: Int //투여양
    
    var createdAt: Date //생성시간
    var updatedAt: Date //변경시간
    
    init(administion: Int, createdAt: Date, updatedAt: Date) {
        self.administion = administion
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
