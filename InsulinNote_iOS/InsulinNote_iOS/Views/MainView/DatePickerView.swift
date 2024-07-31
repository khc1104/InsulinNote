//
//  DatePickerView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var date: Date
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.green)
            DatePicker("", selection: $date)
                .datePickerStyle(.wheel)
        }
    }
}

