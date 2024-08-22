//
//  RecodingIntent.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/16/24.
//

import AppIntents
import SwiftData
import SwiftUI

struct RecodingIntent: AppIntent, AudioPlaybackIntent{
    
    static var title: LocalizedStringResource = "Insulin 기록 하기"
    static var description: IntentDescription = IntentDescription("인슐린을 기록합니다.", categoryName: "<기록>", searchKeywords: ["인슐린", "기록"])
    
    
    
    
    func perform() async throws -> some ProvidesDialog{
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            //predicate: #Predicate{ $},
            sortBy: [
                .init(\.createdAt)
            ]
        )
        
        let context = ModelContextStore.sharedModelContext
        let insulinSettings = try context.fetch(descriptor)
        var insulinSetting = insulinSettings.first
        let record =  InsulinRecordModel(administion: insulinSetting?.administration ?? 99, createdAt: .now, updatedAt: .now)
        insulinSetting?.records?.append(record)
        try await requestConfirmation()
        
        
        return .result(dialog: IntentDialog("기록이 완료되었습니다."))
        
    }
}

//
//struct ItemEntity: AppEntity{
//    var id: UUID
//    var title: String
//
//    var displayRepresentation: DisplayRepresentation{
//        DisplayRepresentation(title: "Title")
//    }
//
//    static var defaultQuery: some EntityQuery = ItemQuery()
//    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Title"
//
//    init(id: UUID, title: String) {
//        self.id = id
//        self.title = title
//    }
//
//    init(setting: InsulinSettingModel){
//        self.id = setting.id
//        self.title = setting.insulinProductName
//    }
//}
//
//struct ItemQuery: EntityQuery{
//    func entities(for identifiers: [ItemEntity.ID]) async throws -> [ItemEntity] {
//        var entities: [ItemEntity] = []
//
//
//
//
//    }
//
//}
