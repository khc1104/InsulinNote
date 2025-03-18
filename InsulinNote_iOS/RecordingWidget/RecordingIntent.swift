//
//  RecodingIntent.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/16/24.
//

import AppIntents
import SwiftData
import SwiftUI

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
        return .result(dialog: IntentDialog("\(insulinSetting?.insulinProductName ?? "dd")"))
        
    }
    
}

struct RecordingEntity: AppEntity, Identifiable{
    let id: UUID
    
    let insulinSetting: InsulinSettingModel
    
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "세팅"
    static var defaultQuery = RecordingQuery()
    
    var displayRepresentation: DisplayRepresentation{
        DisplayRepresentation(title: "\(insulinSetting.insulinProductName) | \(insulinSetting.dosage)")
    }

}

struct RecordingQuery: EntityQuery{
    func entities(for identifiers: [RecordingEntity.ID]) async throws -> [RecordingEntity] {
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            //predicate: #Predicate{ $},
            sortBy: [
                .init(\.createdAt)
            ]
        )
        
        let context = ModelContextStore.sharedModelContext
        let insulinSettings = try context.fetch(descriptor)
        
        return insulinSettings.map{
            RecordingEntity(id: $0.id, insulinSetting: $0)
        }
        
    }
    
    func suggestedEntities() async throws -> [RecordingEntity] {
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            //predicate: #Predicate{ $},
            sortBy: [
                .init(\.createdAt)
            ]
        )
        
        let context = ModelContextStore.sharedModelContext
        let insulinSettings = try context.fetch(descriptor)
        
        return insulinSettings.map{
            RecordingEntity(id: $0.id, insulinSetting: $0)
        }
        
    }
    
    func defaultResult() async -> RecordingEntity? {
        try? await suggestedEntities().first
    }
}
