//
//  InsulinModelContainer.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 8/22/24.
//

import SwiftData

class InsulinModelContainer{
 
    static private let modelContainer: ModelContainer = {
        do{
            let schema = Schema([InsulinSettingModel.self])
            return try ModelContainer(
                for: schema,
                configurations: ModelConfiguration(
                    schema: schema,
                    isStoredInMemoryOnly: false
                )
            )
        }catch{
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    static var sharedModelContext = ModelContext(modelContainer)
}
