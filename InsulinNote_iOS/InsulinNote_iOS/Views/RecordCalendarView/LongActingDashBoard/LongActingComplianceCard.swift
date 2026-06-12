//
//  LongActingComplianceCard.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct LongActingComplianceCard: View {
    let complianceRate: Double
    let streakDays: Int
    
    var body: some View {
        HStack(spacing: 10) {
            // 좌측 원형 프로그레스 바
            CircularProgressRing(progress: complianceRate)
                .padding(.leading, 12)
            
            // 우측 메타 데이터
            VStack(alignment: .leading, spacing: 4) {
                Text("지효성 복약률")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                // 스트릭 뱃지
                HStack(spacing: 3) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .font(.system(.caption))
                    
                    Text("\(streakDays)일 연속")
                        .font(.system(.caption, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Color.orange.opacity(0.12))
                .cornerRadius(6)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical ,12)
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray4).opacity(0.35), lineWidth: 1) // 외곽 테두리 추가로 구분감 부여
        )
    }
}

#Preview {
    HStack {
        LongActingComplianceCard(complianceRate: 0.92, streakDays: 8)
        Spacer()
        LongActingComplianceCard(complianceRate: 0.92, streakDays: 8)
    }
    .padding()
}
