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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(InsulinModelActor.modelContainer)
    }
}
