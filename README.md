# InsulinNote

인슐린 투여 기록에 필요한 행동을 최소화해, 빠르게 기록하고 당일 투여 여부를 확인할 수 있도록 만든 iOS 앱입니다.

## 개요

- 지효성 인슐린을 투여했는지 잊는 문제를 해결하기 위해 시작했습니다.
- 기존 혈당/투여 앱의 복잡한 입력 흐름 대신, 필요한 정보만 빠르게 기록하는 것을 목표로 합니다.
- `당일 지효성 투여 여부 확인`과 `입력 뎁스 최소화`가 가장 중요한 목표입니다.

## 개발 환경

- Xcode 26.0
- iOS 17.0+
- SwiftUI
- SwiftData
- WidgetKit
- AppIntents

## 현재 상태

### 앱 기능

- 메인 화면에서 지효성/속효성 인슐린 기록
- 인슐린 설정 화면(제품명, 기본 투여량 수정)
- 달력 화면에서 날짜별 기록 확인
- 앱 첫 실행 시 기본 인슐린 설정 생성

### 위젯 기능

- 홈 화면 위젯에서 빠른 투여 기록
- 잠금화면 위젯에서 최신 투여 시간 확인

## 아키텍처 및 데이터 처리

- 데이터 저장은 SwiftData를 사용합니다.
- 동시성 이슈를 줄이기 위해, 기존 ModelContext 직접 접근 일부를 `@ModelActor` 기반 접근으로 전환했습니다.
- 현재 Swift 6 마이그레이션은 위 동시성 대응 범위까지 반영된 상태입니다.

## 화면 예시

| 메인 화면 | 캘린더 화면 |
| --- | --- |
|<img width="295" height="640" alt="메인 화면" src="https://github.com/user-attachments/assets/350d0e41-93e8-461e-9120-8aa3fe14aecf" />|<img width="295" height="640" alt="캘린더" src="https://github.com/user-attachments/assets/4361b4c2-3273-412d-9f2d-e267f7f58d1e" />|

| 홈화면 위젯 투여 | 잠금화면 위젯 투여 |
| --- | --- |
|<img width="295" height="640" alt="홈화면 위젯" src="https://github.com/user-attachments/assets/fc66d33b-57bf-4ce0-a94e-26f0c01ea953" />|<img width="295" height="640" alt="잠금화면 위젯" src="https://github.com/user-attachments/assets/b152d7b7-4a99-4894-85b5-bb48bc5d9ab0" />|


## 향후 개선 항목

- Swift 6 전면 적용(현재 적용된 동시성 대응 범위 외 영역 확장)
- HealthKit 연동 검토

