//
//  RecodingIntent.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/16/24.
//

import AppIntents
import SwiftData
import SwiftUI
import WidgetKit

struct RecordingIntent: AppIntent, AudioPlaybackIntent{
    init() {
        
    }
    
    init(id: String?){
        self.seletedInsulinSettingId = id
    }
    
    static var title: LocalizedStringResource = "Insulin 기록 하기"
    static var description: IntentDescription = IntentDescription("인슐린을 기록합니다.", categoryName: "<기록>", searchKeywords: ["인슐린", "기록"])

    @Parameter(title: "setting")
    var seletedInsulinSettingId: String?
    
    func perform() async throws -> some ProvidesDialog{
        SoundPlayer.shared.play()
        
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            //predicate: #Predicate{ $},
            sortBy: [
                .init(\.createdAt)
            ]
        )
        
        let context = ModelContextStore.sharedModelContext
        let insulinSettings = try context.fetch(descriptor)
        let insulinSetting = insulinSettings.filter{$0.id.uuidString == seletedInsulinSettingId}.first
        //print(insulinSetting?.insulinProductName)
        let record =  InsulinRecordModel(dosage: insulinSetting?.dosage ?? 99, createdAt: .now, updatedAt: .now)
        insulinSetting?.records.append(record)
        try await requestConfirmation()
        
        try context.save()
        WidgetCenter.shared.reloadAllTimelines()
        return .result(dialog: IntentDialog("\(insulinSetting?.insulinProductName ?? "dd")"))
        
    }
    
}

struct RecordingEntity: AppEntity, Identifiable{
    let id: UUID
    let insulinProductName: String
    let dosage: Int
    let actingType: InsulinSettingModel.ActingType
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "세팅"
    static var defaultQuery = RecordingQuery()
    
    var displayRepresentation: DisplayRepresentation{
        DisplayRepresentation(title: "\(insulinProductName) | \(dosage)")
    }

}

struct RecordingQuery: EntityQuery{
    func entities(for identifiers: [RecordingEntity.ID]) async throws -> [RecordingEntity] {
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            sortBy: [
                .init(\.createdAt)
            ]
        )
        
        let context = ModelContextStore.sharedModelContext
        let insulinSettings = try context.fetch(descriptor)
        
        return insulinSettings.map{
            RecordingEntity(
                id: $0.id,
                insulinProductName: $0.insulinProductName,
                dosage: $0.dosage,
                actingType: $0.actingType)
        }
        
    }
    
    func suggestedEntities() async throws -> [RecordingEntity] {
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            sortBy: [
                .init(\.createdAt)
            ]
        )
        
        let context = ModelContextStore.sharedModelContext
        let insulinSettings = try context.fetch(descriptor)
        
        return insulinSettings.map{
            RecordingEntity(
                id: $0.id,
                insulinProductName: $0.insulinProductName,
                dosage: $0.dosage,
                actingType: $0.actingType)
        }
        
    }
    
    func defaultResult() async -> RecordingEntity? {
        try? await suggestedEntities().first
    }
}
