//
//  RecordCalendarView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 3/19/25.
//

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
    @State var startDayOfWeek: Int = 0
    @State var selectedYear: Int = 2025
    @State var selectedMonth: Int = 4
    var body: some View {
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
        LazyVGrid(columns: gridItems) {
            ForEach(Weekday.allCases, id: \.self){ dow in
                Text("\(dow.getString())")
            }
            ForEach(1..<(startDayOfWeek + getLastDayOfMonth(selectedYear, selectedMonth)!), id: \.self){ item in
                if item >= startDayOfWeek{
                    Text("\(item - startDayOfWeek + 1)")
                }else{
                    Text("")
                }
            }
        }.onAppear{
            startDayOfWeek = getDayOfTheWeek(selectedYear, selectedMonth)
        }
    }
    func getDayOfTheWeek(_ year:Int, _ month: Int) -> Int{
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        if let date = calendar.date(from: components) {
            let weekday = calendar.component(.weekday, from: date)
            return weekday
        }
        return 0
    }
    func getLastDayOfMonth(_ year:Int, _ month: Int) -> Int?{
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDay = formatter.date(from: "\(year)-\(month)-01")!
        let nextStartDay = calendar.date(byAdding: .month, value: 1, to: startDay)!
        let end = calendar.dateComponents([.day], from: startDay, to:nextStartDay)
        
        guard let day = end.day else { return nil }
        return day
    }
}

#Preview {
    RecordCalendarView()
}
