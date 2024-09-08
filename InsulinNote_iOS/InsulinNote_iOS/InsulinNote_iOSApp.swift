//
//  InsulinNote_iOSApp.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/15/24.
//

import SwiftUI
import SwiftData
import AppIntents

//fileprivate let modelContainer: ModelContainer = {
//    do{
//        let schema = Schema([InsulinSettingModel.self])
//        return try ModelContainer(
//            for: schema,
//            configurations: ModelConfiguration(
//                schema: schema,
//                isStoredInMemoryOnly: false
//            )
//            )
//    }catch{
//        fatalError("Could not create ModelContainer: \(error)")
//    }
//}()

@main
struct InsulinNote_iOSApp: App {
    let context = ModelContextStore.sharedModelContext
    init(){
        //AppDependencyManager.shared.add(dependency: modelContainer)
        
        
    }
     
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(context.container)
    }
}
