//
//  InsulinModelActor.swift
//  InsulinNote
//
//  Created by 권희철 on 10/19/25.
//

import Foundation
import SwiftData

@ModelActor
public actor InsulinModelActor {
    public static let shared = InsulinModelActor(
        modelContainer: {
            do {
                return try ModelContainer(
                    for: InsulinModelActor.schema,
                    configurations: InsulinModelActor.configuration
                )
            } catch {
                fatalError("Failed to create ModelContainer")
            }
        }()
    )

    private static let schema: Schema = .init(
        [InsulinSettingModel.self, InsulinRecordModel.self],
        version: Schema.Version(1, 0, 0)
    )

    private static let configuration: ModelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )

    public func getSettings() -> [InsulinSettingModel] {
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            sortBy: [.init(\InsulinSettingModel.actingType, order: .forward)]
        )
        do {
            let settings = try modelContext.fetch(descriptor)
            return settings
        } catch {
            fatalError("Failed to get Insulin Settings")
        }
    }

    public func fetchAllSettings() -> [InsulinSettingModel] {
        do {
            let descriptor = FetchDescriptor<InsulinSettingModel>(
                sortBy: []
            )
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError("Failed to get Insulin Settings")
        }
    }

    public func fetchSettings(with ids: [UUID]) -> [InsulinSettingModel] {
        let predicate = #Predicate<InsulinSettingModel> { setting in
            ids.contains(setting.id)
        }
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            predicate: predicate
        )
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            fatalError("Failed to fetch Setting by id")
        }
    }

    public func fetchLastRecord(for id: UUID) -> InsulinRecordModel? {
        let todayStart = Calendar.current.startOfDay(for: .now)
        let nextDayStart = todayStart.addingTimeInterval(86400)
        let predicate = #Predicate<InsulinRecordModel> { record in
            return (record.setting?.id == id) && todayStart <= record.createdAt
                && record.createdAt < nextDayStart
        }
        let descriptor = FetchDescriptor<InsulinRecordModel>(
            predicate: predicate,
            sortBy: [.init(\.createdAt, order: .reverse)]
        )
        do {
            return try modelContext.fetch(descriptor).first
        } catch {
            fatalError("The problem occurred during fetch LastRecord")
        }
    }

    // 인슐린 투여기록 추가
    public func addRecord(_ id: PersistentIdentifier, dosage: Int, date: Date) {
        guard let setting = modelContext.model(for: id) as? InsulinSettingModel
        else {
            fatalError("Failed to find InsulinSettingModel")
        }
        let record = InsulinRecordModel(
            dosage: dosage,
            createdAt: date,
            updatedAt: date
        )
        setting.records.append(record)
        self.saveContext()
    }

    // 인슐린 세팅 변경( 이름, 기본 투여량)
    public func updateSetting(
        _ id: PersistentIdentifier,
        insulinProductName: String,
        dosage: Int
    ) {
        guard let setting = modelContext.model(for: id) as? InsulinSettingModel
        else {
            fatalError("Failed to find InsulinSettingModel")
        }
        setting.insulinProductName = insulinProductName
        setting.dosage = dosage

        self.saveContext()
    }

    // 첫 실행시 초기 세팅 생성할 때 씀
    public func createInitSetting() {
        do {
            let descriptor = FetchDescriptor<InsulinSettingModel>()
            if try modelContext.fetchCount(descriptor) == 0 {
                let longActionInsulin = InsulinSettingModel(
                    insulinProductName: "지효성",
                    actingType: .long,
                    dosage: 20,
                    records: [],
                    updatedAt: .now
                )
                modelContext.insert(longActionInsulin)

                let fastActingInsulin = InsulinSettingModel(
                    insulinProductName: "속효성",
                    actingType: .fast,
                    dosage: 15,
                    records: [],
                    updatedAt: .now
                )
                modelContext.insert(fastActingInsulin)

                self.saveContext()
            }
        } catch {
            fatalError("Failed to init Settings")
        }
    }

    private func saveContext() {
        if modelContext.hasChanges {
            do {
                try modelContext.save()
                print("성공")
            } catch {
                fatalError("Failed to insert new InsulinRecordModel")
            }
        }
    }
}
