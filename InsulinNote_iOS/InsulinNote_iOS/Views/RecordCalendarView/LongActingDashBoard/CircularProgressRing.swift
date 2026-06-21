//
//  CircularProgressRing.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct CircularProgressRing: View {
    let progress: Double // 0.0 ~ 1.0
    var lineWidth: CGFloat = 8
    
    var body: some View {
        ZStack {
            // 배경 트랙
            Circle()
                .stroke(
                    Color(.systemGray5),
                    lineWidth: lineWidth
                )
            
            // 진행 표시 원호 (green 사용)
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    Color.green,
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(Angle(degrees: -90))
                .animation(.easeOut(duration: 0.8), value: progress)
            
            // 중앙 백분율 텍스트
            Text("\(Int(progress * 100))%")
                .font(.system(.callout, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(width: 56, height: 56) // 카드 내부에 알맞게 조정한 콤팩트 크기
    }
}

#Preview {
    CircularProgressRing(progress: 0.95)
}
