//
//  DefaultInsulin.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData

@Model
class InsulinSettingModel{
    var insulinProductName: String
    var administration: Int
    var records: [InsulinRecordModel]
    var createdAt: Date
    var updatedAt: Date
    
    init(insulinProductName: String, administration: Int, records: [InsulinRecordModel], updatedAt: Date) {
        self.insulinProductName = insulinProductName
        self.administration = administration
        self.records = records
        self.createdAt = .now
        self.updatedAt = updatedAt
    }
}
