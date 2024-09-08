//
//  ModelContextStore.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/22/24.
//
import SwiftData

final class ModelContextStore{
    static private var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            InsulinSettingModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do{
            return try ModelContainer(for:schema, configurations: [modelConfiguration])
        }catch{
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static var sharedModelContext = ModelContext(sharedModelContainer)
}
