//
//  RecodingIntent.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/16/24.
//

import AppIntents
//import SwiftData
//import SwiftUI

struct RecodingIntent: AppIntent, AudioPlaybackIntent{
    
    static var title: LocalizedStringResource = "Insulin 기록 하기"
    static var description: IntentDescription = IntentDescription("인슐린을 기록합니다.", categoryName: "<기록>", searchKeywords: ["인슐린", "기록"])
    
    //@Environment(\.modelContext) var insulinContext
    
    
    func perform() async throws -> some ProvidesDialog{
        SoundPlayer.shared.play()
        try await requestConfirmation()
        return .result(dialog: IntentDialog("기록이 완료되었습니다."))
    }
    
    
}


