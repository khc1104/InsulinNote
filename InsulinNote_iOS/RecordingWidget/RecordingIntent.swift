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
import os.log

struct RecordingIntent: AppIntent, AudioPlaybackIntent{
    init() {
        
    }
    
    static var title: LocalizedStringResource = "인슐린 기록 하기"
    static var description: IntentDescription = IntentDescription("인슐린을 기록합니다.", categoryName: "<기록>", searchKeywords: ["인슐린", "기록"])

    @Parameter(title: "인슐린 설정")
    var setting: InsulinSettingModel
    
    @Parameter(title: "투여량")
    var dosage: Int
    
    private static let logger = Logger(subsystem: "com.HeeChoel.InsulinNote", category: "RecordingIntent")
    
    public func perform() async throws -> some ProvidesDialog{
        SoundPlayer.shared.play()
        
        Self.logger.log("perform Called")
        await InsulinModelActor.shared.addRecord(
            setting.persistentModelID,
            dosage: self.dosage,
            date: .now
        )
        try await requestConfirmation()
        
        WidgetCenter.shared.reloadAllTimelines()
        
        Self.logger.log("perform End")
        return .result(dialog: IntentDialog("\(setting.insulinProductName)|\(setting.dosage) 투여"))
    }
}
