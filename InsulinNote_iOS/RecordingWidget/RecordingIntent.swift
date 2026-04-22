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
    
    init(id: UUID){
        self.settingID = id.uuidString
    }
    
    static var title: LocalizedStringResource = "인슐린 기록 하기"
    static var description: IntentDescription = IntentDescription("인슐린을 기록합니다.", categoryName: "<기록>", searchKeywords: ["인슐린", "기록"])

    @Parameter(title: "setting ID")
    var settingID: String

    @MainActor
    public func perform() async throws -> some ProvidesDialog{
        do{
            SoundPlayer.shared.play()
            guard let settingUUID = UUID(uuidString: settingID) else {fatalError("Failed to convertUUID on intent") }
            
            guard let setting = try await InsulinModelActor.shared.fetchSettings(with: [settingUUID]).first else { fatalError("Failed to fetchSetting on intent")}
            
            UserDefaults.shared.set(nil, forKey: "lastWidgetError")
            
            try await InsulinModelActor.shared.addRecord(
                setting.persistentModelID,
                dosage: setting.dosage,
                date: .now
            )
            try await requestConfirmation()
            
            WidgetCenter.shared.reloadAllTimelines()
            
            return .result(dialog: IntentDialog("\(setting.insulinProductName)|\(setting.dosage) 투여"))
        } catch {
            let errorMessage = (error as? ModelError)?.localizedDescription ?? "저장 실패"
            UserDefaults.shared.set(errorMessage, forKey: "lastWidgetError")
            return .result(dialog: IntentDialog("\(errorMessage)"))
        }
    }
}
