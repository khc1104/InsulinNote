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
    
    //아직 사용 안함
    /*
    var InsulinModelContainer: ModelContainer = {
        let schema = Schema([
            DefaultInsulin.self,
            InsulinRecord.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    */
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for:[
            DefaultInsulin.self,
            InsulinRecord.self
        ])
    }
}
