//
//  DefaultInsulin.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import Foundation
import SwiftData

@Model
final class InsulinSettingModel: Identifiable, Sendable{
    @Attribute(.unique) var id: UUID = UUID() //id
    
    var insulinProductName: String //인슐린 제품 명
    var type: ActingType
    var dosage: Int //기본 투여량
    
    @Relationship(deleteRule: .cascade, inverse: \InsulinRecordModel.setting)
    var records: [InsulinRecordModel] = [] //해당 설정으로 등록한 투여기록
    
    var createdAt: Date //생성시간
    var updatedAt: Date //변경시간
    
    init(insulinProductName: String, dosage: Int, records: [InsulinRecordModel], updatedAt: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
        self.insulinProductName = insulinProductName
        self.dosage = dosage
        self.records = records
        self.createdAt = .now
        self.updatedAt = updatedAt
    }
}

enum ActingType{ //인슐린 타입
    case long //지효성
    case fast //속효성
}
