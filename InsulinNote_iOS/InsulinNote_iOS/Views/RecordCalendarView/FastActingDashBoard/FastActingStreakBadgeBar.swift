//
//  FastActingStreakBadgeBar.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct FastActingStreakBadgeBar: View {
    var loggedDaysCount: Int = 5 // 이번 주 실제 기록 일수 (0~7)
    var targetDaysCount: Int = 7  // 주간 목표 일수
    let isSmallDevice: Bool // 소형 기기 모드 플래그 추가
    
    var body: some View {
        HStack(spacing: 8) {
            // 좌측 성공 메달 아이콘
            Image(systemName: "checkmark.seal.fill")
                .foregroundColor(.blue)
                .font(.system(isSmallDevice ? .caption : .subheadline))
            
            // 챌린지명
            Text("기록 챌린지")
                .font(.system(isSmallDevice ? .caption2 : .caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            // 가로 프로그레스 바
            GeometryReader { geo in
                let ratio = CGFloat(loggedDaysCount) / CGFloat(targetDaysCount)
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray4).opacity(0.4))
                        .frame(height: 5)
                    
                    Capsule()
                        .fill(Color.blue)
                        .frame(width: geo.size.width * ratio, height: 5)
                        .animation(.easeOut(duration: 0.6), value: loggedDaysCount)
                }
                .frame(maxHeight: .infinity)
            }
            .frame(height: 5)
            
            // 달성 텍스트 및 축하 이모지
            Text("\(loggedDaysCount)/\(targetDaysCount)일 \(loggedDaysCount >= 5 ? "👏" : "")")
                .font(.system(isSmallDevice ? .caption2 : .caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 10)
        .frame(height: isSmallDevice ? 32 : 38) // 소형 기기일 때 높이 압축
        .background(Color(uiColor: .secondarySystemGroupedBackground))         .cornerRadius(8)
    }
}

#Preview {
    FastActingStreakBadgeBar(loggedDaysCount: 5, isSmallDevice: false)
}
