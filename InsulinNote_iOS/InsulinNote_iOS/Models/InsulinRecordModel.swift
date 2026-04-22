//
//  InsulinRecord.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData


@Model
final public class InsulinRecordModel: Identifiable{
    @Attribute(.unique) public var id: UUID = UUID() //id
    
    var dosage: Int //투여양
    
    var createdAt: Date //생성시간
    var updatedAt: Date //변경시간
    
    var dateString: String{
        DateFormatter.yyyyMMdd.string(from: createdAt)
    }
    
    var timeString: String{
        DateFormatter.hourMinute.string(from: createdAt)
    }
    
    var setting: InsulinSettingModel?
    
    init(dosage: Int, createdAt: Date, updatedAt: Date) {
        self.dosage = dosage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
