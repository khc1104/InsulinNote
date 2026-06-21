//
//  RecordCalendarView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 3/19/25.
//

import SwiftData
import SwiftUI

enum Weekday: Int, CaseIterable {

    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    func getString() -> String {
        switch self {
        case .sunday:
            return "일"
        case .monday:
            return "월"
        case .tuesday:
            return "화"
        case .wednesday:
            return "수"
        case .thursday:
            return "목"
        case .friday:
            return "금"
        case .saturday:
            return "토"
        }
    }
}

struct RecordCalendarView: View {
    let gridItems = Array(repeating: GridItem(.flexible()), count: 7)

    @State private var isSheetPresented: Bool = false
    @State private var startDayOfWeek: Int = 0
    @State private var selectedYear: Int = 2025
    @State private var selectedMonth: Int = 4

    @State private var selectedDate: Date? = nil

    // SwiftData 기록 동기화 감시용 쿼리
    @Query private var allRecordsForSync: [InsulinRecordModel]

    // 대시보드 통계 상태 변수 정의 (기본값 제공으로 Layout Shift 방지)
    @State private var complianceRate: Double = 0.0
    @State private var streakDays: Int = 0
    @State private var averageTime: String = "--:--"
    @State private var consistencyScore: Int = 100
    @State private var fastActingPoints: [ChartPoint] = []
    @State private var weeklyLoggedDays: Int = 0
    @State private var fastActingMedalCount: Int = 0

    var currentDate: Date = Date()
    private var today: [Int] {
        var dateElements: [Int] = []
        let dateString = DateFormatter.yyyyMMdd.string(from: currentDate)
        let dateArray = dateString.split(separator: "-")
        dateElements.append(Int(dateArray[0])!)
        dateElements.append(Int(dateArray[1])!)
        dateElements.append(Int(dateArray[2])!)
        return dateElements
    }

    @Environment(\.modelContext) var insulinContext

    // 달력 주차(Row 수) 자동 계산 (HIG 자가 검증 대응)
    private func getCalendarWeeks(_ year: Int, _ month: Int, _ startDay: Int) -> Int {
        let lastDay = getLastDayOfMonth(year, month) ?? 30
        let totalSlots = startDay - 1 + lastDay
        return Int(ceil(Double(totalSlots) / 7.0))
    }

    private func getLastDayOfMonth(_ year: Int, _ month: Int) -> Int? {
        let calendar = Calendar.current
        guard let start = DateFormatter.yyyyMMdd.date(from: "\(year)-\(String(format: "%02d", month))-01") else { return nil }
        let next = calendar.date(byAdding: .month, value: 1, to: start)!
        return calendar.dateComponents([.day], from: start, to: next).day
    }

    var body: some View {
        GeometryReader { geo in
            // 3단계 기기 높이 분류 (HIG 보완본)
            let isMiniDevice = geo.size.height < 700
            let isLargeDevice = geo.size.height >= 780
            let isSmallDevice = !isLargeDevice // mini + regular 모두 콤팩트 모드

            let calendarWeeks = getCalendarWeeks(selectedYear, selectedMonth, startDayOfWeek)
            let isTightMonth = calendarWeeks >= 6

            // 스페이싱 매트릭스: 기기 크기 × 주차 수 조합
            let mainSpacing: CGFloat = isLargeDevice ? 12
                : (isTightMonth ? (isMiniDevice ? 3 : 6) : (isMiniDevice ? 6 : 8))

            ZStack {
                Color(uiColor: .systemGroupedBackground).ignoresSafeArea()

                VStack(spacing: mainSpacing) {
                    // 상단 년월 탐색 헤더
                    HStack(spacing: 20) {
                        Button {
                            withAnimation {
                                selectedMonth -= 1
                                if selectedMonth == 0 {
                                    selectedYear -= 1
                                    selectedMonth = 12
                                }
                                startDayOfWeek = getDayOfTheWeek(
                                    selectedYear,
                                    selectedMonth
                                )
                            }
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(isSmallDevice ? .title3 : .title2, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .frame(
                                    width: 44,
                                    height: isSmallDevice ? 36 : 44
                                )  // HIG 준수 터치 영역
                        }
                        Text("\(selectedYear.description)년 \(selectedMonth)월")
                            .font(.system(.title3, design: .rounded))
                            .fontWeight(.bold)

                        Button {
                            withAnimation {
                                selectedMonth += 1
                                if selectedMonth == 13 {
                                    selectedYear += 1
                                    selectedMonth = 1
                                }
                                startDayOfWeek = getDayOfTheWeek(
                                    selectedYear,
                                    selectedMonth
                                )
                            }
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.system(.title3, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .frame(
                                    width: 44,
                                    height: isSmallDevice ? 36 : 44
                                )  // HIG 준수 터치 영역
                        }
                    }
//                    .padding(.top, 6)0

                    // [세션 1] 달력 카드 세션 (자체 카드배경 및 테두리 탑재)
                    MonthlyRecordGridView(
                        gridItems: gridItems,
                        startDayOfWeek: startDayOfWeek,
                        selectedYear: selectedYear,
                        selectedMonth: selectedMonth,
                        today: today,
                        isSmallDevice: isSmallDevice,
                        calendarWeeks: calendarWeeks,
                        selectedDate: $selectedDate
                    )
                    // [세션 2] 지효성 대시보드 카드 세션 (가로 분할 및 얇은 테두리)
                    HStack(spacing: 10) {
                        LongActingComplianceCard(
                            complianceRate: complianceRate,
                            streakDays: streakDays
                        )
                        LongActingConsistencyCard(
                            averageTime: averageTime,
                            consistencyScore: consistencyScore
                        )
                    }
                    .padding(.horizontal)

                    // [세션 3] 속효성 대시보드 산점도 차트, 스트릭
                    FastActingPatternChart(
                        points: fastActingPoints,
                        isSmallDevice: isSmallDevice,
                        isTightMonth: isTightMonth
                    )
                        .background(
                            Color(uiColor: .secondarySystemGroupedBackground)
                        )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    Color(.systemGray4).opacity(0.3),
                                    lineWidth: 1
                                )  // 외곽 얇은 실선으로 카드 형태 그룹화
                        )
                        .padding(.horizontal)
                    FastActingStreakBadgeBar(
                        loggedDaysCount: weeklyLoggedDays,
                        medalCount: fastActingMedalCount,
                        isSmallDevice: isSmallDevice
                    )
                    .padding(.horizontal)

                }
                .onAppear {
                    selectedYear = today[0]
                    selectedMonth = today[1]
                    startDayOfWeek = getDayOfTheWeek(
                        selectedYear,
                        selectedMonth
                    )
                }
                .sheet(item: $selectedDate) { date in
                    RecordView(date: date)
                }
                .task(id: "\(selectedYear)-\(selectedMonth)") {
                    await loadDashboardData()
                }
                .onChange(of: allRecordsForSync) { _, _ in
                    Task {
                        await loadDashboardData()
                    }
                }
            }
        }

    }

    private func loadDashboardData() async {
        do {
            let compliance = try await InsulinModelActor.shared.fetchLongActingCompliance(for: selectedYear, month: selectedMonth)
            let consistency = try await InsulinModelActor.shared.fetchLongActingConsistency(for: selectedYear, month: selectedMonth)
            let points = try await InsulinModelActor.shared.fetchFastActingChartPoints(for: selectedYear, month: selectedMonth)
            let weeklyDays = try await InsulinModelActor.shared.fetchFastActingWeeklyLoggedDays()
            let medal = try await InsulinModelActor.shared.fetchFastActingGoldMedalCount()
            
            await MainActor.run {
                self.complianceRate = compliance.complianceRate
                self.streakDays = compliance.streakDays
                self.averageTime = consistency.averageTime
                self.consistencyScore = consistency.consistencyScore
                self.fastActingPoints = points
                self.weeklyLoggedDays = weeklyDays
                self.fastActingMedalCount = medal
            }
        } catch {
            print("대시보드 데이터 연산 실패: \(error)")
        }
    }

    // 1일이 무슨 요일인지 찾는 함수
    func getDayOfTheWeek(_ year: Int, _ month: Int) -> Int {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        if let date = calendar.date(from: components) {
            let weekday = calendar.component(.weekday, from: date)
            return weekday
        }
        return 0
    }
}

#Preview {
    RecordCalendarView()
}
