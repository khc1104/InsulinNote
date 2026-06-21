//
//  fastActingInsulinView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/9/24.
//

import SwiftUI
import SwiftData

struct FastActingInsulinView: View {
    @Environment(\.modelContext) var insulinContext

    let date: Date
    let setting: InsulinSettingModel?
    let hasInjectedLongActingToday: Bool
    let onButtonTapped: () -> Void
    let onEditTapped: () -> Void
    let onRecordTapped: (InsulinRecordModel) -> Void
    
    private var todayRecords: [InsulinRecordModel] {
        if let setting {
            let calendar = Calendar.current
            return setting.records.filter {
                calendar.isDate($0.createdAt, inSameDayAs: date)
            }.sorted(by: { $0.createdAt > $1.createdAt })
        } else {
            return []
        }
    }
    
    var body: some View {
        if let setting {
            VStack(alignment: .leading, spacing: 0) {
                // Header Row
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.fastActing)
                        .frame(width: 10, height: 10)
                    
                    Text("속효성 인슐린 (\(setting.insulinProductName))")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color.fastActing)
                    
                    Spacer()
                    
                    Button {
                        onEditTapped()
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.system(size: 20))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Content Area (Scrollable records or Empty state)
                if todayRecords.isEmpty {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("오늘 기록된 속효성 인슐린이 없습니다.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    .frame(height: 70)
                    Spacer()
                } else {
                    ScrollView(.vertical) {
                        VStack(spacing: 10) {
                            ForEach(todayRecords) { record in
                                Button {
                                    onRecordTapped(record)
                                } label: {
                                    HStack {
                                        Text(record.timeString)
                                            .font(.system(size: 16))
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(record.dosage) 단위")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(Color.fastActing)
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(height: 54)
                                    .background(Color(uiColor: .systemGroupedBackground))
                                    .cornerRadius(12)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .scrollIndicators(.hidden)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    Spacer(minLength: 16)
                }
                
                // Add Inject Button (Figma: 310x44 button)
                Button {
                    onButtonTapped()
                } label: {
                    Text(todayRecords.isEmpty ? "투여하기" : "추가 투여")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.fastActing)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(minHeight: 200, maxHeight: .infinity)
            .background(Color(uiColor: .secondarySystemGroupedBackground))
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
        }
    }
}
