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

    private let calendar = Calendar.autoupdatingCurrent
    private let localMonToSunCalendar: Calendar = {
        var cal = Calendar.autoupdatingCurrent
        cal.firstWeekday = 2
        return cal
    }()

    private static let schema: Schema = .init(
        [InsulinSettingModel.self, InsulinRecordModel.self],
        version: Schema.Version(1, 0, 0)
    )

    private static let configuration: ModelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )
    // MARK: - 기본 CRUD
    public func fetchAllSettings() throws ->  [InsulinSettingModel] {
        do {
            let descriptor = FetchDescriptor<InsulinSettingModel>(
                sortBy: []
            )
            return try modelContext.fetch(descriptor)
        } catch {
            throw ModelError.fetchSettingError
        }
    }

    public func fetchSettings(with ids: [UUID]) throws -> [InsulinSettingModel] {
        let predicate = #Predicate<InsulinSettingModel> { setting in
            ids.contains(setting.id)
        }
        let descriptor = FetchDescriptor<InsulinSettingModel>(
            predicate: predicate
        )
        do {
            return try modelContext.fetch(descriptor)
        } catch {
            throw ModelError.fetchSettingError
        }
    }

    public func fetchLastRecord(for id: UUID) throws -> InsulinRecordModel? {
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
            throw ModelError.fetchRecordError
        }
    }

    // 인슐린 투여기록 추가
    public func addRecord(_ id: PersistentIdentifier, dosage: Int, date: Date) throws {
        guard let setting = modelContext.model(for: id) as? InsulinSettingModel
        else {
            throw ModelError.updateDataError
        }
        let record = InsulinRecordModel(
            dosage: dosage,
            createdAt: date,
            updatedAt: date
        )
        setting.records.append(record)
        try self.saveContext()
    }

    // 인슐린 세팅 변경( 이름, 기본 투여량)
    public func updateSetting  (
        _ id: PersistentIdentifier,
        insulinProductName: String,
        dosage: Int
    ) throws {
        guard let setting = modelContext.model(for: id) as? InsulinSettingModel
        else {
            throw ModelError.updateDataError
        }
        setting.insulinProductName = insulinProductName
        setting.dosage = dosage

        try self.saveContext()
    }
    
    // 투여 기록 수정
    public func updateRecord(
        _ id: PersistentIdentifier,
        dosage: Int,
        date: Date
    ) throws {
        guard let record = modelContext.model(for: id) as? InsulinRecordModel
        else {
            throw ModelError.updateDataError
        }
        record.dosage = dosage
        record.createdAt = date
        record.updatedAt = .now
        
        try self.saveContext()
    }
    
    // 투여 기록 삭제
    public func deleteRecord(_ id: PersistentIdentifier) throws {
        guard let record = modelContext.model(for: id) as? InsulinRecordModel
        else {
            throw ModelError.updateDataError
        }
        modelContext.delete(record)
        
        try self.saveContext()
    }
    
    // 첫 실행시 초기 세팅 생성할 때 씀
    public func createInitSetting() throws {
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

                try self.saveContext()
            }
        } catch {
            throw ModelError.createInitSettingError
        }
    }

    // MARK: - 캘린더 뷰에서 쓰이는 함수들 및 쿼리 최적화
    
    // 특정 ActingType에 해당하는 세팅의 ID를 가져오는 Helper 메서드
    private func fetchSettingId(for actingType: InsulinSettingModel.ActingType) throws -> UUID? {
        do {
            let descriptor = FetchDescriptor<InsulinSettingModel>()
            let settings = try modelContext.fetch(descriptor)
            return settings.first(where: { $0.actingType == actingType })?.id
        } catch {
            throw ModelError.fetchSettingError
        }
    }

    // 1. 지효성 인슐린 복약률 및 연속 기록(Streak) 연산
    public func fetchLongActingCompliance(for year: Int, month: Int) throws -> (complianceRate: Double, streakDays: Int) {
        guard let targetSettingId = try fetchSettingId(for: .long) else {
            return (0.0, 0)
        }
        
        guard let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            throw ModelError.fetchRecordError
        }
        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
            throw ModelError.fetchRecordError
        }
        
        // DB 레벨에서 기간 및 지효성 ID를 필터링
        let predicate = #Predicate<InsulinRecordModel> { record in
            startDate <= record.createdAt && record.createdAt < nextMonthDate && record.setting?.id == targetSettingId
        }
        let descriptor = FetchDescriptor<InsulinRecordModel>(predicate: predicate)
        let longRecords = try modelContext.fetch(descriptor)
        
        let now = Date()
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: now)
        
        let isCurrentMonth = (todayComponents.year == year && todayComponents.month == month)
        let totalDays: Int
        let targetEndDate: Date
        
        if isCurrentMonth {
            totalDays = todayComponents.day ?? 1
            targetEndDate = calendar.startOfDay(for: now)
        } else {
            let range = calendar.range(of: .day, in: .month, for: startDate)
            totalDays = range?.count ?? 30
            guard let lastDayDate = calendar.date(byAdding: .day, value: totalDays - 1, to: startDate) else {
                throw ModelError.fetchRecordError
            }
            targetEndDate = calendar.startOfDay(for: lastDayDate)
        }
        
        let recordDates = Set(longRecords.map { calendar.startOfDay(for: $0.createdAt) })
        let loggedDaysCount = recordDates.count
        
        let complianceRate = totalDays > 0 ? Double(loggedDaysCount) / Double(totalDays) : 0.0
        
        var streak = 0
        var checkDate = targetEndDate
        
        // 전체 기록 중 지효성만 DB 레벨에서 필터링해서 가져옴
        let longAllPredicate = #Predicate<InsulinRecordModel> { record in
            record.setting?.id == targetSettingId
        }
        var longAllDescriptor = FetchDescriptor<InsulinRecordModel>(predicate: longAllPredicate)
        longAllDescriptor.sortBy = [.init(\.createdAt, order: .reverse)]
        let allLongRecords = try modelContext.fetch(longAllDescriptor)
        let allLongDates = Set(allLongRecords.map { calendar.startOfDay(for: $0.createdAt) })
        
        while allLongDates.contains(checkDate) {
            streak += 1
            guard let prevDate = calendar.date(byAdding: .day, value: -1, to: checkDate) else { break }
            checkDate = prevDate
        }
        
        return (complianceRate, streak)
    }

    // 2. 지효성 인슐린 평균 투여 시간 및 일관성 점수 연산
    public func fetchLongActingConsistency(for year: Int, month: Int) throws -> (averageTime: String, consistencyScore: Int) {
        guard let targetSettingId = try fetchSettingId(for: .long) else {
            return ("기록 없음", 100)
        }
        
        guard let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            throw ModelError.fetchRecordError
        }
        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
            throw ModelError.fetchRecordError
        }
        
        // DB 레벨 필터링
        let predicate = #Predicate<InsulinRecordModel> { record in
            startDate <= record.createdAt && record.createdAt < nextMonthDate && record.setting?.id == targetSettingId
        }
        let descriptor = FetchDescriptor<InsulinRecordModel>(predicate: predicate)
        let longRecords = try modelContext.fetch(descriptor)
        
        guard !longRecords.isEmpty else {
            return ("기록 없음", 100)
        }
        
        if longRecords.count == 1 {
            let firstRecord = longRecords[0]
            let timeStr = DateFormatter.doseTimeKorean.string(from: firstRecord.createdAt)
            return (timeStr, 100)
        }
        
        let minutesArray = longRecords.map { record -> Int in
            let comp = calendar.dateComponents([.hour, .minute], from: record.createdAt)
            return (comp.hour ?? 0) * 60 + (comp.minute ?? 0)
        }
        
        let sum = minutesArray.reduce(0, +)
        let avgMinutes = sum / minutesArray.count
        
        let avgHour = avgMinutes / 60
        let avgMin = avgMinutes % 60
        let tempDate = calendar.date(bySettingHour: avgHour, minute: avgMin, second: 0, of: Date()) ?? Date()
        let averageTimeStr = DateFormatter.doseTimeKorean.string(from: tempDate)
        
        let absoluteErrors = minutesArray.map { minutes -> Double in
            let diff = abs(minutes - avgMinutes)
            let cyclicDiff = min(diff, 1440 - diff)
            return Double(cyclicDiff)
        }
        
        let meanAbsoluteError = absoluteErrors.reduce(0.0, +) / Double(absoluteErrors.count)
        
        let score: Int
        if meanAbsoluteError <= 30.0 {
            score = 100
        } else if meanAbsoluteError <= 60.0 {
            score = 95
        } else if meanAbsoluteError <= 120.0 {
            score = 90
        } else if meanAbsoluteError <= 180.0 {
            score = 85
        } else {
            score = 80
        }
        
        return (averageTimeStr, score)
    }

    // 3. 속효성 인슐린 차트용 좌표 목록 연산
    public func fetchFastActingChartPoints(for year: Int, month: Int) throws -> [ChartPoint] {
        guard let fastSettingId = try fetchSettingId(for: .fast) else {
            return []
        }
        
        guard let startDate = calendar.date(from: DateComponents(year: year, month: month, day: 1)) else {
            throw ModelError.fetchRecordError
        }
        guard let nextMonthDate = calendar.date(byAdding: .month, value: 1, to: startDate) else {
            throw ModelError.fetchRecordError
        }
        
        // DB 레벨 필터링
        let predicate = #Predicate<InsulinRecordModel> { record in
            startDate <= record.createdAt && record.createdAt < nextMonthDate && record.setting?.id == fastSettingId
        }
        let descriptor = FetchDescriptor<InsulinRecordModel>(predicate: predicate)
        let fastRecords = try modelContext.fetch(descriptor)
        
        return fastRecords.map { record in
            let comp = calendar.dateComponents([.hour, .minute, .weekday], from: record.createdAt)
            let hour = Double(comp.hour ?? 0)
            let minute = Double(comp.minute ?? 0)
            let time = hour + (minute / 60.0)
            let dosage = Double(record.dosage)
            let dayOfWeek = comp.weekday ?? 1
            
            return ChartPoint(
                time: time,
                dosage: dosage,
                dayOfWeek: dayOfWeek
            )
        }
    }

    // 4. 주간 속효성 기록 일수 연산 (월~일 기준)
    public func fetchFastActingWeeklyLoggedDays() throws -> Int {
        guard let fastSettingId = try fetchSettingId(for: .fast) else {
            return 0
        }
        
        let now = Date()
        
        guard let startOfWeek = localMonToSunCalendar.dateInterval(of: .weekOfYear, for: now)?.start else {
            throw ModelError.fetchRecordError
        }
        guard let endOfWeek = localMonToSunCalendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            throw ModelError.fetchRecordError
        }
        
        // DB 레벨 필터링 (주간 범위 + 속효성 ID)
        let predicate = #Predicate<InsulinRecordModel> { record in
            startOfWeek <= record.createdAt && record.createdAt < endOfWeek && record.setting?.id == fastSettingId
        }
        let descriptor = FetchDescriptor<InsulinRecordModel>(predicate: predicate)
        let fastRecords = try modelContext.fetch(descriptor)
        
        let loggedDates = Set(fastRecords.map { calendar.startOfDay(for: $0.createdAt) })
        return loggedDates.count
    }

    // 5. 누적 골드 메달 개수 연산
    public func fetchFastActingGoldMedalCount() throws -> Int {
        guard let fastSettingId = try fetchSettingId(for: .fast) else {
            return 0
        }
        
        // DB 레벨에서 속효성 인슐린 데이터만 처음부터 Fetch
        let predicate = #Predicate<InsulinRecordModel> { record in
            record.setting?.id == fastSettingId
        }
        let descriptor = FetchDescriptor<InsulinRecordModel>(predicate: predicate)
        let fastRecords = try modelContext.fetch(descriptor)
        
        var weekToDatesMap: [String: Set<Date>] = [:]
        
        for record in fastRecords {
            let startOfDay = calendar.startOfDay(for: record.createdAt)
            
            let components = localMonToSunCalendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: record.createdAt)
            if let year = components.yearForWeekOfYear, let week = components.weekOfYear {
                let key = "\(year)-W\(week)"
                weekToDatesMap[key, default: Set()].insert(startOfDay)
            }
        }
        
        let completedWeeksCount = weekToDatesMap.values.filter { $0.count >= 7 }.count
        return completedWeeksCount
    }

    private func saveContext() throws {
        if modelContext.hasChanges {
            do {
                try modelContext.save()
                print("성공")
            } catch {
                throw ModelError.updateDataError
            }
        }
    }
}
