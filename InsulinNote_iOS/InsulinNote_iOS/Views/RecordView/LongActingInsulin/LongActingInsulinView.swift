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
    
    private var injectedRecordToday: InsulinRecordModel? {
        injectedAtToday(setting: setting)
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
                    if let injectedRecordToday{
                        LongActingInsulinIsInjectedView(insulinRecord:injectedRecordToday ,proxy: proxy)
                    }else{
                        LongActingInsulinIsNotInjectedView(proxy: proxy, onButtonTapped: onButtonTapped)
                    }
                }.border(Color.longActing, width: 1)
            }
        }
    }
    
    private func injectedAtToday(setting: InsulinSettingModel?) -> InsulinRecordModel?{
        guard let setting else { return nil}
        let calendar = Calendar.current
        
        let recentRecord = setting.records.max(by: { lhs, rhs in
            lhs.createdAt > rhs.createdAt
        })
        
        if let recentRecord, calendar.isDateInToday(recentRecord.createdAt) {
            return recentRecord
        }
        
        return nil
    }
    
}
