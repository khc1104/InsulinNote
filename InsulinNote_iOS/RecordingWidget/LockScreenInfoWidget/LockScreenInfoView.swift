//
//  LockScreenInfoView.swift
//  InsulinNote
//
//  Created by 권희철 on 9/18/25.
//

import SwiftData
import SwiftUI

struct LockScreenInfoView: View {

    var entry: LastDoseEntry
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    var body: some View {
        VStack {
            HStack {
                Text("\(entry.longActingName)")
                Spacer()
                Text(
                    "\(formatter.string(for: entry.longActingLastDoseInToday) ?? "기록 없음")"
                )

            }
            HStack {
                Text("\(entry.FastActingName)")
                Spacer()
                Text(
                    "\(formatter.string(for: entry.fastActingLastDoseInToday) ?? "기록 없음")"
                )
            }
        }
        .containerBackground(for: .widget) {
            Color.primary
        }
    }
}
