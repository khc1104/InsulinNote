//
//  MonthlyRecordGridView.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI
import SwiftData

struct MonthlyRecordGridView: View {
    let gridItems: [GridItem]
    let startDayOfWeek: Int
    let selectedYear: Int
    let selectedMonth: Int
    let today: [Int]
    let isSmallDevice: Bool // 소형 기기 모드 플래그 추가
    let calendarWeeks: Int  // 달력 Row 수 (4, 5, 6)
    @Binding var selectedDate: Date?

    @Query private var records: [InsulinRecordModel]

    init(
        gridItems: [GridItem],
        startDayOfWeek: Int,
        selectedYear: Int,
        selectedMonth: Int,
        today: [Int],
        isSmallDevice: Bool,
        calendarWeeks: Int,
        selectedDate: Binding<Date?>
    ) {
        self.gridItems = gridItems
        self.startDayOfWeek = startDayOfWeek
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
        self.today = today
        self.isSmallDevice = isSmallDevice
        self.calendarWeeks = calendarWeeks
        _selectedDate = selectedDate

        let calendar = Calendar.current
        let monthStart = calendar.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1)) ?? .now
        let nextMonthStart = calendar.date(byAdding: .month, value: 1, to: monthStart) ?? monthStart.addingTimeInterval(86400 * 31)

        _records = Query(
            filter: #Predicate<InsulinRecordModel> { record in
                record.createdAt >= monthStart && record.createdAt < nextMonthStart
            }
        )
    }

    private var injectedLongDays: Set<Int> {
        let calendar = Calendar.current
        var set = Set<Int>()
        for record in records {
            guard record.setting?.actingType == .long else { continue }
            let day = calendar.component(.day, from: record.createdAt)
            set.insert(day)
        }
        return set
    }

    var body: some View {
        // 주차 수에 따른 동적 셀 높이 및 그리드 간격 계산 (HIG 44pt 준수)
        let gridSpacing: CGFloat = calendarWeeks >= 6 ? 2 : (isSmallDevice ? 2 : 4)
        let cellMinHeight: CGFloat = calendarWeeks >= 6
            ? (isSmallDevice ? 34 : 36)
            : (isSmallDevice ? 36 : 44)

        VStack(spacing: gridSpacing)  {
            LazyVGrid(columns: gridItems, spacing: gridSpacing) {
                ForEach(Weekday.allCases, id: \.self) { dow in
                    Text("\(dow.getString())")
                        .font(.system(isSmallDevice ? .caption2 : .footnote, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .frame(height: 16)
                }

                let lastDay = getLastDayOfMonth(selectedYear, selectedMonth) ?? 30
                ForEach(1..<(startDayOfWeek + lastDay), id: \.self) { item in
                    let day = item - startDayOfWeek + 1

                    if item >= startDayOfWeek {
                        let isToday = selectedYear == today[0] && selectedMonth == today[1] && day == today[2]
                        let isLongActingInjected = injectedLongDays.contains(day)
                        let isTappable = isDayTappable(year: selectedYear, month: selectedMonth, day: day)
                        
                        CalendarDayCellView(
                            day: day,
                            isToday: isToday,
                            isLongActingInjected: isLongActingInjected,
                            isTappable: isTappable,
                            isSmallDevice: isSmallDevice,
                            cellMinHeight: cellMinHeight,
                            onTap: {
                                selectedDate = intToDate(year: selectedYear, month: selectedMonth, day: day)
                            }
                        )
                    } else {
                        Spacer()
                            .frame(height: cellMinHeight)
                    }
                }
            }
        }
        .padding(calendarWeeks >= 6 ? 10 : 14)
                .background(Color(uiColor: .secondarySystemGroupedBackground)) // 전체 달력을 담는 카드배경
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4).opacity(0.3), lineWidth: 1) // 구분선 보강을 위한 외곽선
        )
        .padding(.horizontal)
    }

    // 월의 마지막날을 찾는 함수
    private func getLastDayOfMonth(_ year: Int, _ month: Int) -> Int? {
        let calendar = Calendar.current
        guard let startDay = DateFormatter.yyyyMMdd.date(from: "\(year)-\(String(format: "%02d", month))-01") else { return nil }
        let nextStartDay = calendar.date(byAdding: .month, value: 1, to: startDay)!
        let end = calendar.dateComponents([.day], from: startDay, to: nextStartDay)

        guard let day = end.day else { return nil }
        return day
    }

    private func intToDate(year: Int, month: Int, day: Int) -> Date {
        let dateString = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day)) 23:59:59"
        return DateFormatter.yyyyMMddHHmmss.date(from: dateString) ?? Date()
    }

    /// 오늘(포함) 이후·미래 월은 탭 불가. 과거 일만 RecordView로 연다.
    private func isDayTappable(year: Int, month: Int, day: Int) -> Bool {
        let calendar = Calendar.current
        guard
            let cellDate = calendar.date(from: DateComponents(year: year, month: month, day: day)),
            let todayDate = calendar.date(from: DateComponents(year: today[0], month: today[1], day: today[2]))
        else { return false }
        let cellStart = calendar.startOfDay(for: cellDate)
        let todayStart = calendar.startOfDay(for: todayDate)
        return cellStart < todayStart
    }
}
