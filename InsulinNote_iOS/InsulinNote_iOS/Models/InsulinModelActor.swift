//
//  InsulinModelActor.swift
//  InsulinNote
//
//  Created by 권희철 on 10/19/25.
//

import SwiftData

@ModelActor
public actor InsulinModelActor {
    nonisolated static let modelContainer: ModelContainer = {
        do {
            let schema: Schema = .init(
                [InsulinSettingModel.self, InsulinRecordModel.self],
                version: Schema.Version(1, 0, 0)
            )
            
            let configuration: ModelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false)
            return try ModelContainer(for: schema, configurations: configuration)
        } catch {
            fatalError("Failed to create modelContainer")
        }
    }()
        

    public func insert<T: PersistentModel>(newModel: T) {
        modelContext.insert(newModel)
        print(newModel)
        self.saveContext()
    }
    
    func updateSetting(_ id: PersistentIdentifier, insulinProductName: String, dosage: Int) {
        guard let record = modelContext.model(for: id) as? InsulinSettingModel else {
            fatalError("Failed to find InsulinSettingModel")
        }
        record.insulinProductName = insulinProductName
        record.dosage = dosage
        
        self.saveContext()
    }
    
    func insertSetting() {
        let longActionInsulin = InsulinSettingModel(insulinProductName: "지효성", actingType: .long, dosage: 20, records: [], updatedAt: .now)
        modelContext.insert(longActionInsulin)
        
        let fastActingInsulin = InsulinSettingModel(insulinProductName: "속효성", actingType: .fast, dosage: 15, records: [], updatedAt: .now)
        modelContext.insert(fastActingInsulin)
        
        self.saveContext()
    }
    
    private func saveContext() {
        if modelContext.hasChanges {
            do {
                try modelContext.save()
                print("성공")
            } catch{
                fatalError("Failed to insert new InsulinRecordModel")
            }
        }
    }
}

