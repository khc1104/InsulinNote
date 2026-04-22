//
//  InsulinNote_iOSApp.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/15/24.
//

import SwiftUI
import SwiftData

@main
struct InsulinNote_iOSApp: App {
    @State private var errorManager = ErrorManager()
    
    var body: some Scene {
        WindowGroup {
            if errorManager.isCriticalError {
                ContentUnavailableView {
                    Label("에러 발생", systemImage: "exclamationmark.triangle")
                } description: {
                    Text(errorManager.error?.localizedDescription ?? "")
                } actions: {
                    Button ("새로 고침") {
                        errorManager.error = nil
                    }
                }
            } else {
                ContentView()
                    .environment(errorManager)
                    .alert(isPresented: Binding(
                        get: { errorManager.isAlertError },
                        set: { if !$0 { errorManager.error = nil }}
                    ), error: errorManager.error) {_ in
                        Button("확인", role: .cancel) {
                            errorManager.error = nil
                        }
                    } message: { error in
                        Text(error.recoverySuggestion ?? "")
                    }
            }
        }
        .modelContainer(InsulinModelActor.shared.modelContainer)
    }
}
