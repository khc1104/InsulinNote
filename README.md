![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 10 46 57](https://github.com/user-attachments/assets/ff7d9579-13ad-4b47-a708-ae70d710130c)# InsulinNote
인슐린 투여 여부를 기록하는 iOS어플리케이션

## 개요
지효성 인슐린 투여를 했는지 안했는지 까먹는 경우를 해결하기 위해 만듬.   
현재 혈당 체크기와 연동하는 앱은 너무 무겁고 수기기록 시 너무 많은 정보를 요구해 복잡함.   
최대한 가볍고 최대한 간단한 행동으로 기록할 수 있도록 하는 것이 목표임.   

## 개발 환경
1. Xcode Version 15.4
1. iOS 17.0

## 개발한 기능

|홈화면 위젯|잠금화면 위젯|
|--------|----------|
|![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 10 42 07](https://github.com/user-attachments/assets/2e145e62-2825-4802-98ce-96d2ef35293e)|![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 10 46 57](https://github.com/user-attachments/assets/1bcf8c04-ed31-46c5-bfcc-fd7b64252e6f)|
|지효성 인슐린 투여|속효성 인슐린 투여|
|![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 10 44 18](https://github.com/user-attachments/assets/cb851a91-caea-4b31-bd1d-c93437cf9836)|![Simulator Screen Recording - iPhone 16 Pro - 2025-04-24 at 10 43 38](https://github.com/user-attachments/assets/b3874943-0a99-4abf-8734-a147efb7886b)|




## UI/UX 피드백
1. UI/UX 디자인을 할 때는 이 앱을 통해 전달해야 할 정보의 우선순위를 먼저 생각해야 한다.
1. 우선순위가 큰 순으로 사용자에게 보여주는 비율이 커야한다.
1. 지금 가장 중요한 기능은 지효성 인슐린의 당일 투여 여부를 확인 하는 것
1. 그 다음은 속효성 인슐린의 투여 기록

## 현재 완성된 작업
1. 메인 뷰
1. 인슐린 설정 뷰
1. 달력 뷰
1. 홈스크린 위젯에서 지효성 인슐린 기록하는 기능
1. 락스크린에서 지효성 인슐린 투여 기록하는 기능
1. SwiftCuncurrency를 위해 modelActor 사용

## 개선 사항
1. HealthKit 사용

