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
            HStack{
                Button{
                    selectedMonth -= 1
                    if selectedMonth == 0{
                        selectedYear -= 1
                        selectedMonth = 12
                    }
                    startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
                } label: {
                    Image(systemName: "chevron.left")
                }
                Text("\(selectedYear.description)년 \(selectedMonth)월")
                    .font(.title)
                Button{
                    selectedMonth += 1
                    if selectedMonth == 13{
                        selectedYear += 1
                        selectedMonth = 1
                    }
                    startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
                } label: {
                    Image(systemName: "chevron.right")
                }
            }
            MonthlyRecordGridView(
                gridItems: gridItems,
                startDayOfWeek: startDayOfWeek,
                selectedYear: selectedYear,
                selectedMonth: selectedMonth,
                today: today,
                selectedDate: $selectedDate
            )
        }.onAppear{
            selectedYear = today[0]
            selectedMonth = today[1]
            startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
        }.sheet(item: $selectedDate) { date in
            RecordView(date: date)
        }
    }
    //1일이 무슨 요일인지 찾는 함수
    func getDayOfTheWeek(_ year:Int, _ month: Int) -> Int{
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        if let date = calendar.date(from: components) {
            let weekday = calendar.component(.weekday, from: date)
            return weekday
        }
        return 0
    }
    //월의 마지막날을 찾는 함수
    func getLastDayOfMonth(_ year:Int, _ month: Int) -> Int?{
        let calendar = Calendar.current
        let startDay = DateFormatter.yyyyMMdd.date(from: "\(year)-\(month)-01")!
        let nextStartDay = calendar.date(byAdding: .month, value: 1, to: startDay)!
        let end = calendar.dateComponents([.day], from: startDay, to:nextStartDay)
        
        guard let day = end.day else { return nil }
        return day
    }
    
    func intToDate(year: Int, month: Int, day: Int) -> Date{
        let dateString = "\(year)-\(String(format: "%02d", month))-\(String(format: "%02d", day)) 23:59:59"
        return DateFormatter.yyyyMMddHHmmss.date(from: dateString) ?? Date()
    }
}

private struct MonthlyRecordGridView: View {
    let gridItems: [GridItem]
    let startDayOfWeek: Int
    let selectedYear: Int
    let selectedMonth: Int
    let today: [Int]
    @Binding var selectedDate: Date?

    @Query private var records: [InsulinRecordModel]

    init(
        gridItems: [GridItem],
        startDayOfWeek: Int,
        selectedYear: Int,
        selectedMonth: Int,
        today: [Int],
        selectedDate: Binding<Date?>
    ) {
        self.gridItems = gridItems
        self.startDayOfWeek = startDayOfWeek
        self.selectedYear = selectedYear
        self.selectedMonth = selectedMonth
        self.today = today
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
        LazyVGrid(columns: gridItems) {
            ForEach(Weekday.allCases, id: \.self) { dow in
                Text("\(dow.getString())")
            }

            let lastDay = getLastDayOfMonth(selectedYear, selectedMonth) ?? 30
            ForEach(1..<(startDayOfWeek + lastDay), id: \.self) { item in
                let day = item - startDayOfWeek + 1

                if item >= startDayOfWeek {
                    ZStack {
                        if selectedYear == today[0] && selectedMonth == today[1] && day == today[2] { // 오늘
                            Circle()
                                .fill(.yellow)
                                .opacity(0.3)
                                .frame(maxWidth: 30, maxHeight: 30)
                        }

                        if injectedLongDays.contains(day) {
                            Circle()
                                .stroke(
                                    Color.green,
                                    style: StrokeStyle(lineWidth: 1.0)
                                )
                                .frame(maxWidth: 30, maxHeight: 30)
                        }

                        if isDayTappable(year: selectedYear, month: selectedMonth, day: day) {
                            Text("\(day)")
                                .frame(maxWidth: 40, maxHeight: 45)
                                .onTapGesture {
                                    selectedDate = intToDate(year: selectedYear, month: selectedMonth, day: day)
                                }
                        } else {
                            Text("\(day)").frame(maxWidth: 40, maxHeight: 45)
                        }
                    }
                } else {
                    Text("")
                }
            }
        }
    }

    // 월의 마지막날을 찾는 함수
    private func getLastDayOfMonth(_ year: Int, _ month: Int) -> Int? {
        let calendar = Calendar.current
        let startDay = DateFormatter.yyyyMMdd.date(from: "\(year)-\(month)-01")!
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

#Preview {
    RecordCalendarView()
}
