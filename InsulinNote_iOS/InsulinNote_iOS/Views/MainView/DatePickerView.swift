//
//  DatePickerView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 7/28/24.
//

import SwiftUI

struct DatePickerView: View {
    @State var date: Date = Date()
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundStyle(.green)
            DatePicker("", selection: $date)
                .datePickerStyle(.wheel)
        }
    }
}

#Preview {
    DatePickerView()
}
