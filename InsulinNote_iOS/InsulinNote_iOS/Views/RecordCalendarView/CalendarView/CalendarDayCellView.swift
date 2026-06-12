//
//  CalendarDayCellView.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct CalendarDayCellView: View {
    let day: Int
    let isToday: Bool
    let isLongActingInjected: Bool
    let isTappable: Bool
    let isSmallDevice: Bool // 소형 기기 모드 플래그 추가
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            let circleSize: CGFloat = isSmallDevice ? 24 : 30
            
            // 오늘 날짜 노란색 원
            if isToday {
                Circle()
                    .fill(Color.yellow)
                    .opacity(0.3)
                    .frame(width: circleSize, height: circleSize)
            }
            
            // 지효성 복약 기록이 있는 날 초록색 외곽선
            if isLongActingInjected {
                Circle()
                    .stroke(
                        Color.green,
                        style: StrokeStyle(lineWidth: isSmallDevice ? 1.0 : 1.5)
                    )
                    .frame(width: circleSize, height: circleSize)
            }
            
            // 날짜 숫자
            Text("\(day)")
                .font(.system(isSmallDevice ? .callout : .body, design: .rounded))
                .fontWeight(isToday ? .bold : .regular)
                .foregroundColor(isTappable ? .primary : .secondary.opacity(0.5))
        }
        .frame(maxWidth: .infinity, minHeight: isSmallDevice ? 34 : 44) // 소형 기기일 때 높이를 34pt로 조절
        .contentShape(Rectangle()) // 터치 제스처 영역 유지
        .onTapGesture {
            if isTappable {
                onTap()
            }
        }
    }
}

#Preview {
    HStack {
        CalendarDayCellView(day: 10, isToday: true, isLongActingInjected: true, isTappable: true, isSmallDevice: true, onTap: {})
        CalendarDayCellView(day: 11, isToday: false, isLongActingInjected: true, isTappable: true, isSmallDevice: false, onTap: {})
    }
}
