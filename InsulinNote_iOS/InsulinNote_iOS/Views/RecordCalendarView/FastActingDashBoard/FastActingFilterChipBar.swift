//
//  FastActingFilterChipBar.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct FastActingFilterChipBar: View {
    @Binding var selectedFilter: String
    let isSmallDevice: Bool // 소형 기기 모드 플래그 추가
    
    let filters = ["전체", "평일", "주말", "월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: isSmallDevice ? 6 : 8) {
                ForEach(filters, id: \.self) { filter in
                    let isSelected = selectedFilter == filter
                    
                    Text(filter)
                        .font(.system(isSmallDevice ? .caption : .footnote, design: .rounded))
                        .fontWeight(isSelected ? .bold : .medium)
                        .foregroundColor(isSelected ? .white : .primary)
                        .padding(.horizontal, isSmallDevice ? 10 : 14)
                        .padding(.vertical, isSmallDevice ? 6 : 8) // 12 mini일 때 패딩 축소
                        .background(
                            Capsule()
                                .fill(isSelected ? Color.blue : Color(.systemGray5))
                        )
                        .contentShape(Capsule())
                        .onTapGesture {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.75)) {
                                selectedFilter = filter
                            }
                        }
                }
            }
            .padding(.horizontal, 4) // 마스터 카드의 기본 여백이 적용되므로 조밀하게 설정
        }
        .frame(height: isSmallDevice ? 34 : 44) // 소형 기기일 때 34pt 높이로 압축
    }
}

#Preview {
    FastActingFilterChipBar(selectedFilter: .constant("전체"), isSmallDevice: false)
}
