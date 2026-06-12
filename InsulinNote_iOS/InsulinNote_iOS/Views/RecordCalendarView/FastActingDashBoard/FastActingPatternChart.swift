//
//  FastActingPatternChart.swift
//  InsulinNote
//
//  Created by 권희철 on 6/10/26.
//

import SwiftUI

struct FastActingPatternChart: View {
    
    let isSmallDevice: Bool  // 소형 기기 모드 플래그 추가
    
    // 차트 좌표 매핑을 위한 데이터 모델 구조체 정의 추가
    struct ChartPoint: Identifiable {
        let id = UUID()
        let time: Double  // 0.0 ~ 24.0 (시간대 실수형)
        let dosage: Double  // 0.0 ~ 20.0 (투여량 단위수)
        let dayOfWeek: Int  // 1(일) ~ 7(토)
    }

    // 차트 레이아웃에 시각적 시연을 위한 정교한 목업 데이터 목록
    private let mockPoints: [ChartPoint] = [
        ChartPoint(time: 7.5, dosage: 4.0, dayOfWeek: 2),  // 월요일 아침
        ChartPoint(time: 8.2, dosage: 5.5, dayOfWeek: 3),  // 화요일 아침
        ChartPoint(time: 7.8, dosage: 4.5, dayOfWeek: 4),  // 수요일 아침
        ChartPoint(time: 12.2, dosage: 6.0, dayOfWeek: 2),  // 월요일 점심
        ChartPoint(time: 12.5, dosage: 7.0, dayOfWeek: 5),  // 목요일 점심
        ChartPoint(time: 13.0, dosage: 5.5, dayOfWeek: 7),  // 토요일 점심 (주말)
        ChartPoint(time: 18.5, dosage: 8.0, dayOfWeek: 3),  // 화요일 저녁
        ChartPoint(time: 19.0, dosage: 9.5, dayOfWeek: 4),  // 수요일 저녁
        ChartPoint(time: 19.5, dosage: 11.0, dayOfWeek: 1),  // 일요일 저녁 (주말)
        ChartPoint(time: 20.0, dosage: 8.5, dayOfWeek: 6),  // 금요일 저녁
        ChartPoint(time: 21.0, dosage: 4.0, dayOfWeek: 5),  // 목요일 야식
        ChartPoint(time: 11.5, dosage: 6.5, dayOfWeek: 6),  // 금요일 점심
        ChartPoint(time: 8.5, dosage: 3.5, dayOfWeek: 7),  // 토요일 아침 (주말)
        ChartPoint(time: 18.0, dosage: 8.0, dayOfWeek: 1),  // 일요일 저녁 (주말)
    ]

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
                            .position(x: xOffset, y: height + 10)
                    }

                    // 3. 데이터 점 (Dot) 매핑 및 그리기
                    ForEach(mockPoints) { point in
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
            .frame(height: isSmallDevice ? 115 : 160)  // 소형 기기 시 높이를 115pt로 유기적 수축
        }
    }
    
}
