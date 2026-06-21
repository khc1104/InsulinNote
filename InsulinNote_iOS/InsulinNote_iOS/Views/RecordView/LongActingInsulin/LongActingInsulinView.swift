//
//  LongActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/10/24.
//

import SwiftUI
import SwiftData

struct LongActingInsulinView:View {

    let date: Date
    let setting: InsulinSettingModel?
    let proxy: GeometryProxy
    let onButtonTapped: () -> Void
    let onEditTapped: () -> Void
    let onRecordTapped: (InsulinRecordModel) -> Void
    
    private var recordInDate: InsulinRecordModel? {
        dosedInDate(setting: setting)
    }

    init(
        date: Date,
        setting: InsulinSettingModel?,
        proxy: GeometryProxy,
        onButtonTapped: @escaping () -> Void,
        onEditTapped: @escaping () -> Void,
        onRecordTapped: @escaping (InsulinRecordModel) -> Void
    ) {
        self.date = date
        self.setting = setting
        self.proxy = proxy
        self.onButtonTapped = onButtonTapped
        self.onEditTapped = onEditTapped
        self.onRecordTapped = onRecordTapped
    }
    
    var body: some View {
        if let setting {
            VStack(alignment: .leading, spacing: 8) {
                if let recordInDate {
                    LongActingInsulinIsInjectedView(
                        setting: setting,
                        insulinRecord: recordInDate,
                        proxy: proxy,
                        onButtonTapped: { onRecordTapped(recordInDate) },
                        onEditTapped: onEditTapped
                    )
                    .frame(maxHeight: .infinity)
                } else {
                    LongActingInsulinIsNotInjectedView(
                        setting: setting,
                        proxy: proxy,
                        onButtonTapped: onButtonTapped,
                        onEditTapped: onEditTapped
                    )
                    .frame(maxHeight: .infinity)
                }
            }
        }
    }

    private func dosedInDate(setting: InsulinSettingModel?) -> InsulinRecordModel? {
        guard let setting else { return nil }
        let calendar = Calendar.current
        
        let filteredRecords = setting.records.filter{
            calendar.isDate($0.createdAt, inSameDayAs: date)
        }
        return filteredRecords.first
    }
    
}
