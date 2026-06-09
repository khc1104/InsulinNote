//
//  LongActingInsulinIsNotInjectedView.swift
//  InsulinNote_iOS
//
//  Created by 권희철 on 9/11/24.
//

import SwiftUI

struct LongActingInsulinIsNotInjectedView: View {
    let setting: InsulinSettingModel
    let proxy: GeometryProxy
    let onButtonTapped: () -> Void
    let onEditTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header Row
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.longActing)
                    .frame(width: 10, height: 10)
                
                Text("지효성 인슐린 (\(setting.insulinProductName))")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.longActing)
                
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
            
            Spacer()
            
            // Subtitle status
            Text("오늘은 아직 투여하지 않았습니다.")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .padding(.horizontal, 20)
            
            Spacer()
            
            // Inject Button
            Button {
                onButtonTapped()
            } label: {
                Text("투여하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                    .background(Color.longActing)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .frame(minHeight: 160, maxHeight: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 4)
    }
}
