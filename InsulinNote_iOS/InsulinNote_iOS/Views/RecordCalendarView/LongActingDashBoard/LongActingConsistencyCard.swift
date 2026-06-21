//
//  LongActingConsistencyCard.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct LongActingConsistencyCard: View {
    let averageTime: String
    let consistencyScore: Int
    
    private var ratingInfo: (text: String, color: Color) {
        if consistencyScore >= 96 {
            return ("Perfect", .green)
        } else if consistencyScore >= 90 {
            return ("Good", .blue)
        } else if consistencyScore >= 80 {
            return ("Normal", .orange)
        } else {
            return ("Weak", .red)
        }
    }
    
    var body: some View {
        HStack(spacing: 10) {
            // 좌측: 시계 아이콘 (CircularProgressRing과의 대칭 구조 확보)
            ZStack {
                Circle()
                    .fill(ratingInfo.color.opacity(0.12))
                    .frame(width: 56, height: 56)
                
                Image(systemName: "clock.fill")
                    .font(.system(.title3))
                    .foregroundColor(ratingInfo.color)
            }
            .padding(.leading, 6)
            
            // 우측: 투여 정보 및 등급 뱃지
            VStack(alignment: .leading, spacing: 4) {
                Text("평균 투여 시간")
                    .font(.system(.caption, design: .rounded))
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                Text(averageTime)
                    .font(.system(.footnote, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // 일관성 등급 뱃지
                Text(ratingInfo.text)
                    .font(.system(.caption2, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(ratingInfo.color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(ratingInfo.color.opacity(0.12))
                    .cornerRadius(6)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 12)
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
        LongActingConsistencyCard(averageTime: "오전 08:30", consistencyScore: 98)
        LongActingConsistencyCard(averageTime: "오전 09:40", consistencyScore: 88)
    }
    .padding()
}
