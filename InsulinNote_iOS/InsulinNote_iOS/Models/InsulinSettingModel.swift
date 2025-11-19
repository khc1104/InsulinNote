//
//  DefaultInsulin.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/16/24.
//

import SwiftData
import AppIntents


@Model
final public class InsulinSettingModel: Identifiable, AppEntity, Sendable{
    public var id: UUID = UUID() //id
    
    var insulinProductName: String //인슐린 제품 명
    var actingType: ActingType
    var dosage: Int //기본 투여량
    
    @Relationship(deleteRule: .cascade, inverse: \InsulinRecordModel.setting)
    var records: [InsulinRecordModel] = [] //해당 설정으로 등록한 투여기록
    
    var createdAt: Date //생성시간
    var updatedAt: Date //변경시간
    
    init(insulinProductName: String, actingType: ActingType, dosage: Int, records: [InsulinRecordModel], updatedAt: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"
        self.insulinProductName = insulinProductName
        self.actingType = actingType
        self.dosage = dosage
        self.records = records
        self.createdAt = .now
        self.updatedAt = updatedAt
    }
    
    enum ActingType: Int, Codable, Comparable{
        case long = 0//지속성
        case fast = 1//속효성
        public static func < (lhs: ActingType, rhs: ActingType) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }
        
    }
    
// MARK: - AppIntent
    public var displayRepresentation: DisplayRepresentation{
        DisplayRepresentation(title: "\(insulinProductName)")
    }
    
    static public var typeDisplayRepresentation: TypeDisplayRepresentation = "인슐린 설정"
    static public var defaultQuery = InsulinSettingQuery()
}

