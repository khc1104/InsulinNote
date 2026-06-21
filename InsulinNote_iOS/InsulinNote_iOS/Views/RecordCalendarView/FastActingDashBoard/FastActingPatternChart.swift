//
//  FastActingPatternChart.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct FastActingPatternChart: View {
    
    let points: [ChartPoint]
    let isSmallDevice: Bool  // 소형 기기 모드 플래그 추가
    let isTightMonth: Bool   // 6주 달 여부 (산점도 높이 압축)

    // 현재 선택된 필터 조건에 부합하는지 판단하는 필터 함수
    private func isPointActive(_ point: ChartPoint) -> Bool {
        switch selectedFilter {
        case "전체":
            return true
        case "평일":
            return point.dayOfWeek >= 2 && point.dayOfWeek <= 6
        case "주말":
            return point.dayOfWeek == 1 || point.dayOfWeek == 7
        case "월": return point.dayOfWeek == 2
        case "화": return point.dayOfWeek == 3
        case "수": return point.dayOfWeek == 4
        case "목": return point.dayOfWeek == 5
        case "금": return point.dayOfWeek == 6
        case "토": return point.dayOfWeek == 7
        case "일": return point.dayOfWeek == 1
        default:
            return true
        }
    }

    @State var selectedFilter: String = "전체"

    var body: some View {
        VStack(spacing: 8) {
            // 헤더 정보
            VStack {
                HStack {
                    Text("속효성 투여 패턴")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Spacer()

                }
                .padding(.horizontal, 2)

                FastActingFilterChipBar(
                    selectedFilter: $selectedFilter,
                    isSmallDevice: isSmallDevice
                )
                HStack {
                    Spacer()
                    Text("시간대별 투여량 (0-20U)")
                        .font(.system(.caption2, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)

            // 차트 캔버스 영역
            GeometryReader { geo in
                let width = geo.size.width - 40  // 좌측 Y축 텍스트 공간 확보
                let height = geo.size.height - 20  // 하단 X축 텍스트 공간 확보

                ZStack(alignment: .topLeading) {
                    // 1. Y축 가이드라인 및 단위 텍스트 그리기 (0U, 5U, 10U, 15U, 20U)
                    ForEach(0..<5) { index in
                        let value = 20 - (index * 5)
                        let yOffset = CGFloat(index) * (height / 4)

                        Path { path in
                            path.move(to: CGPoint(x: 35, y: yOffset))
                            path.addLine(to: CGPoint(x: width + 35, y: yOffset))
                        }
                        .stroke(
                            Color(.systemGray4).opacity(0.3),
                            lineWidth: 0.8
                        )

                        Text("\(value)U")
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.secondary)
                            .frame(width: 30, alignment: .trailing)
                            .position(x: 15, y: yOffset)
                    }

                    // 2. X축 가이드라인 및 시간 텍스트 그리기 (00시 ~ 24시)
                    ForEach(0..<5) { index in
                        let hour = index * 6
                        let xOffset = 35 + CGFloat(index) * (width / 4)

                        Path { path in
                            path.move(to: CGPoint(x: xOffset, y: 0))
                            path.addLine(to: CGPoint(x: xOffset, y: height))
                        }
                        .stroke(
                            Color(.systemGray4).opacity(0.3),
                            lineWidth: 0.8
                        )

                        Text(String(format: "%02d:00", hour))
                            .font(.system(.caption2, design: .rounded))
                            .foregroundColor(.secondary)
                            .frame(
                                width: 45,
                                height: 16,
                                alignment: index == 0 ? .leading : (index == 4 ? .trailing : .center)
                            )
                            .position(
                                x: index == 0 ? xOffset + 22.5 : (index == 4 ? xOffset - 22.5 : xOffset),
                                y: height + 10
                            )
                    }

                    // 3. 데이터 점 (Dot) 매핑 및 그리기
                    ForEach(points) { point in
                        let xPos = 35 + CGFloat(point.time / 24.0) * width
                        let yPos = CGFloat(1.0 - (point.dosage / 20.0)) * height
                        let isActive = isPointActive(point)

                        Circle()
                            .fill(Color.blue)  // Color.fastActing에서 Color.blue로 롤백
                            .opacity(isActive ? 0.85 : 0.08)  // 비활성화된 요일은 8% 투명도로 페이드
                            .frame(
                                width: isActive
                                    ? (isSmallDevice ? 8 : 10)
                                    : (isSmallDevice ? 6 : 8)
                            )
                            .scaleEffect(isActive ? 1.25 : 0.85)
                            .position(x: xPos, y: yPos)
                            .animation(
                                .spring(response: 0.35, dampingFraction: 0.75),
                                value: selectedFilter
                            )
                    }
                }
            }
            .frame(height: isTightMonth ? (isSmallDevice ? 125 : 140) : 160)  // 동적 높이 적용
        }
    }
    
}
