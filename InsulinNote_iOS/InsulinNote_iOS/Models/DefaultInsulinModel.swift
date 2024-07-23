//
//  DefaultInsulin.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData

@Model
class DefaultInsulinModel{
    var insulinProductName: String
    var administration: Int
    var createdAt: Date
    var updatedAt: Date
    
    init(insulinProductName: String, administration: Int, updatedAt: Date) {
        self.insulinProductName = insulinProductName
        self.administration = administration
        self.createdAt = .now
        self.updatedAt = updatedAt
    }
}
