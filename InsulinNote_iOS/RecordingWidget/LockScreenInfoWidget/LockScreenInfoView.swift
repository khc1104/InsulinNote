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

    var body: some View {
        VStack {
            HStack {
                Text("\(entry.longActingName)")
                Spacer()
                Text(
                    "\(DateFormatter.hourMinute.string(for: entry.longActingLastDoseInToday) ?? "기록 없음")"
                )

            }
            HStack {
                Text("\(entry.FastActingName)")
                Spacer()
                Text(
                    "\(DateFormatter.hourMinute.string(for: entry.fastActingLastDoseInToday) ?? "기록 없음")"
                )
            }
        }
        .containerBackground(for: .widget) {
            Color.primary
        }
    }
}
