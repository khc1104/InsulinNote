//
//  FormatStyles.swift
//  InsulinNote
//
//  Created by 권희철 on 12/31/25.
//

import Foundation

struct DateFormat {
    let dateWeekday = Date.FormatStyle()
        .year()
        .month()
        .day()
        .weekday()
        .locale(Locale(identifier: "ko_KR"))
    
    let date = Date.FormatStyle()
        .year()
        .month()
        .day()
        .locale(Locale(identifier: "ko_KR"))
    
    let yearMonth = Date.FormatStyle()
        .year()
        .month()
        .locale(Locale(identifier: "ko_KR"))
    
    let time = Date.FormatStyle()
        .hour(.twoDigits(amPM: .wide))
        .minute()
        .locale(Locale(identifier: "ko_KR"))
        
}
