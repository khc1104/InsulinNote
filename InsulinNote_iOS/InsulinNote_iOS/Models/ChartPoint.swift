//
//  ChartPoint.swift
//  InsulinNote
//
//  Created by 권희철 on 6/16/26.
//

import Foundation

public struct ChartPoint: Identifiable, Sendable {
    public let id: UUID
    public let time: Double      // 0.0 ~ 24.0 (시간대 실수형)
    public let dosage: Double    // 0.0 ~ 20.0 (투여량 단위수)
    public let dayOfWeek: Int    // 1(일) ~ 7(토)

    public init(id: UUID = UUID(), time: Double, dosage: Double, dayOfWeek: Int) {
        self.id = id
        self.time = time
        self.dosage = dosage
        self.dayOfWeek = dayOfWeek
    }
}
