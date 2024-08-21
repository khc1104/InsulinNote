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
    
    @Dependency
    private var modelContainer: ModelContainer
    
    
    
    func perform() async throws -> some ProvidesDialog{
        let context = ModelContext(modelContainer)
//        
//        @Query(sort: \InsulinSettingModel.createdAt) var insulinSettings: [InsulinSettingModel]
//        var firstInsulinSetting: InsulinSettingModel = insulinSettings.first ?? InsulinSettingModel(insulinProductName: "이름", administration: 1, records: [], updatedAt: .now)
//        var newInsulinRecord: InsulinRecordModel = InsulinRecordModel(administion: firstInsulinSetting.administration, createdAt: .now, updatedAt: .now)
//        firstInsulinSetting.records?.append(newInsulinRecord)
//        
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
