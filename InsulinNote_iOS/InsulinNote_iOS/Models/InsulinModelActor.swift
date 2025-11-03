//
//  InsulinModelActor.swift
//  InsulinNote
//
//  Created by 권희철 on 10/19/25.
//

import SwiftData
import Foundation

@ModelActor
public actor InsulinModelActor {
    public static let shared = InsulinModelActor(modelContainer: {
        do{
             return try ModelContainer(
                for: InsulinModelActor.schema,
                configurations: InsulinModelActor.configuration)
        } catch {
            fatalError("Failed to create ModelContainer")
        }
    }())
    
    private static let schema: Schema = .init(
        [InsulinSettingModel.self, InsulinRecordModel.self],
        version: Schema.Version(1, 0, 0)
    )
    
    private static let configuration: ModelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false)
    
    
    public func insert<T: PersistentModel>(newModel: T) {
        modelContext.insert(newModel)
        print(newModel)
        self.saveContext()
    }
    
    public func updateSetting(_ id: PersistentIdentifier, insulinProductName: String, dosage: Int) {
        guard let setting = modelContext.model(for: id) as? InsulinSettingModel else {
            fatalError("Failed to find InsulinSettingModel")
        }
        setting.insulinProductName = insulinProductName
        setting.dosage = dosage
        
        self.saveContext()
    }
    
    public func addRecord(_ id: PersistentIdentifier, dosage: Int, date: Date) {
        guard let setting = modelContext.model(for: id) as? InsulinSettingModel else {
            fatalError("Failed to find InsulinSettingModel")
        }
        let record = InsulinRecordModel(dosage: dosage, createdAt: date, updatedAt: date)
        setting.records.append(record)
        self.saveContext()
    }
    
    // 첫 실행시 초기 세팅 생성할 때 씀
    public func createInitSetting() {
        do{
            let descriptor = FetchDescriptor<InsulinSettingModel>()
            if try modelContext.fetchCount(descriptor) == 0 {
                let longActionInsulin = InsulinSettingModel(insulinProductName: "지효성", actingType: .long, dosage: 20, records: [], updatedAt: .now)
                modelContext.insert(longActionInsulin)
                
                let fastActingInsulin = InsulinSettingModel(insulinProductName: "속효성", actingType: .fast, dosage: 15, records: [], updatedAt: .now)
                modelContext.insert(fastActingInsulin)
                
                self.saveContext()
            }
        } catch{
            fatalError("Failed to init Settings")
        }
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

