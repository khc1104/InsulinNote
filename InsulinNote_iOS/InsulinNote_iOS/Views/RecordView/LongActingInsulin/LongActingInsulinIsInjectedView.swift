//
//  LongActingInsulinIsInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI

struct LongActingInsulinIsInjectedView: View {
    let setting: InsulinSettingModel
    let insulinRecord: InsulinRecordModel
    let proxy: GeometryProxy
    let onButtonTapped: () -> Void
    let onEditTapped: () -> Void
    
    var injectedTime: String {
        DateFormatter.hourMinute.string(from: insulinRecord.createdAt)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Row
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 10, height: 10)
                
                Text("지효성 인슐린 (\(setting.insulinProductName))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button {
                    onEditTapped()
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            
            Spacer()
            
            // Large Status Text
            Text("\(injectedTime) 투여 완료 (\(insulinRecord.dosage)단위)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Edit Record Button
            Button {
                onButtonTapped()
            } label: {
                Text("기록 수정")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.longActing)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 160, maxHeight: .infinity)
        .background(Color.longActing)
        .cornerRadius(20)
        .shadow(color: Color.longActing.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
