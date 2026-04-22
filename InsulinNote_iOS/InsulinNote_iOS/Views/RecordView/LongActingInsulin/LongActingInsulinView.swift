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
    
    private var recordInDate: InsulinRecordModel? {
        dosedInDate(setting: setting)
    }

    init(date: Date, setting: InsulinSettingModel?, proxy: GeometryProxy, onButtonTapped: @escaping () -> Void) {
        self.date = date
        self.setting = setting
        self.proxy = proxy
        self.onButtonTapped = onButtonTapped
    }
    var body: some View {
        VStack(alignment: .leading){
            if let setting{
                Text(setting.insulinProductName)
                    .font(.title)
                    .foregroundStyle(Color.longActing)
                VStack{
                    if let recordInDate{
                        LongActingInsulinIsInjectedView(insulinRecord:recordInDate ,proxy: proxy)
                    }else{
                        LongActingInsulinIsNotInjectedView(proxy: proxy, onButtonTapped: onButtonTapped)
                    }
                }.border(Color.longActing, width: 1)
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
