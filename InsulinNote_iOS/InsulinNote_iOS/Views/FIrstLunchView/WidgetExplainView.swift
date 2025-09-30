//
//  WidgetExplainView.swift
//  InsulinNote
//
//  Created by 권희철 on 9/25/25.
//

import SwiftUI

struct WidgetExplainView: View {
    private let explainText: [Int: String] = [
        1: "홈 화면에서 빈공간을 길게 눌러주세요.",
        2: "왼쪽 상단의 편집 버튼을 누르고 위젯 추가를 눌러주세요.",
        3: "검색 칸에 InsulinNote를 검색하거나 위젯 목록에서 선택해 주세요.",
        4: "위젯을 드래그 하거나 추가버튼을 눌러 홈화면에 위젯을 추가해주세요",
        5: "홈 편집 상태에서 위젯을 탭하거나 통상모드에서 위젯을 길게 탭하여 위젯 옵션을 수정 할 수 있습니다.",
        6: "옵션을 바꾸어 지효성 인슐린과 속효성 인슐린 모두 기록 가능 합니다.",
    ]
    @State private var explainNumber = 1

    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(alignment: .center) {
            Image("addWidget\(explainNumber)")
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(explainText[explainNumber] ?? "")
                .frame(minHeight: 90)
                .padding(10)
                .font(.title2)
            Button {
                if explainNumber < 6 {
                    explainNumber += 1
                } else {
                    dismiss()
                }
            } label: {
                Text("\(explainNumber < 6 ? "다 음" : "완 료")")
                    .bold()
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.primary)
                    .background(in: .capsule, fillStyle: FillStyle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 1)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                if explainNumber > 1 {
                    Button {
                        explainNumber -= 1
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                }
            }
            
        }
    }
}

#Preview {
    NavigationStack {
        WidgetExplainView()
    }
}
