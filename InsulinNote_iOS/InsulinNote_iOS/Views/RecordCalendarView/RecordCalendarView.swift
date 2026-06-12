//
//  RecordCalendarView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 3/19/25.
//

import SwiftUI
import SwiftData

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
    
    var currentDate: Date = Date()
    private var today: [Int]{
        var dateElements: [Int] = []
        let dateString = DateFormatter.yyyyMMdd.string(from: currentDate)
        let dateArray = dateString.split(separator: "-")
        dateElements.append(Int(dateArray[0])!)
        dateElements.append(Int(dateArray[1])!)
        dateElements.append(Int(dateArray[2])!)
        return dateElements
    }
    
    @Environment(\.modelContext) var insulinContext
    
    var body: some View {
        VStack{
            GeometryReader { geo in
                // iPhone 12 mini 및 소형 기기 가용 영역 판정 (세로 700pt 미만)
                let isSmallDevice = geo.size.height < 700
                ZStack{
                    Color(uiColor: .systemGroupedBackground).ignoresSafeArea()
                    
                    VStack(spacing:12) {
                        // 상단 년월 탐색 헤더
                        HStack(spacing: 20) {
                            Button {
                                withAnimation {
                                    selectedMonth -= 1
                                    if selectedMonth == 0 {
                                        selectedYear -= 1
                                        selectedMonth = 12
                                    }
                                    startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
                                }
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .frame(width: 44, height: isSmallDevice ? 36 : 44) // HIG 준수 터치 영역
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
                                    startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
                                }
                            } label: {
                                Image(systemName: "chevron.right")
                                    .font(.system(.title3, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                    .frame(width: 44, height: isSmallDevice ? 36 : 44) // HIG 준수 터치 영역
                            }
                        }
                        .padding(.top, 6)
                        
                        // [세션 1] 달력 카드 세션 (자체 카드배경 및 테두리 탑재)
                        MonthlyRecordGridView(
                            gridItems: gridItems,
                            startDayOfWeek: startDayOfWeek,
                            selectedYear: selectedYear,
                            selectedMonth: selectedMonth,
                            today: today,
                            isSmallDevice: isSmallDevice,
                            selectedDate: $selectedDate
                        )
                        // [세션 2] 지효성 대시보드 카드 세션 (가로 분할 및 얇은 테두리)
                        HStack(spacing: 10) {
                            LongActingComplianceCard(complianceRate: 0.95, streakDays: 12)
                            LongActingConsistencyCard(averageTime: "오전 08:30", consistencyScore: 98)
                        }
                        .padding(.horizontal)
                        
                        // [세션 3] 속효성 대시보드 산점도 차트, 스트릭
                        FastActingPatternChart(isSmallDevice: isSmallDevice)
                            .background(Color(uiColor: .secondarySystemGroupedBackground))
                            .cornerRadius(16)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1) // 외곽 얇은 실선으로 카드 형태 그룹화
                            )
                            .padding(.horizontal)
                        FastActingStreakBadgeBar(loggedDaysCount: 5, isSmallDevice: isSmallDevice)
                            .padding(.horizontal)
                        
                    }
                    .onAppear {
                        selectedYear = today[0]
                        selectedMonth = today[1]
                        startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
                    }
                    .sheet(item: $selectedDate) { date in
                        RecordView(date: date)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
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
