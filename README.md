# InsulinNote
인슐린 투여 여부를 기록하는 iOS어플리케이션

## 개요
지효성 인슐린 투여를 했는지 안했는지 까먹는 경우를 해결하기 위해 만듬.   
현재 혈당 체크기와 연동하는 앱은 너무 무겁고 수기기록 시 너무 많은 정보를 요구해 복잡함.   
최대한 가볍고 최대한 간단한 행동으로 기록할 수 있도록 하는 것이 목표임.   

## 개발 환경
1. Xcode Version 15.4
1. iOS 17.0

## 개발한 기능
|평소 투여하는 양 설정하는 페이지|인슐린 투여량 기록 페이지|
|------------------------|-------------------|
|![Simulator Screen Recording - iPhone 15 Pro - 2024-08-03 at 16 53 01](https://github.com/user-attachments/assets/9b38c068-91df-431f-96ba-d72e961fe553)|![Simulator Screen Recording - iPhone 15 Pro - 2024-08-03 at 17 00 41](https://github.com/user-attachments/assets/cd91d595-5130-4e8f-b45a-634dbf296443)|
|인슐린 투여 기록을 바탕으로 다음 처방 받을 펜 계산하는 페이지|인터렉티브 위젯으로 기록하기|
|![Simulator Screen Recording - iPhone 15 Pro - 2024-09-08 at 18 08 42](https://github.com/user-attachments/assets/31c4df0f-c2a2-4f62-b108-fbde583ca7e3)|![Simulator Screen Recording - iPhone 15 Pro - 2024-09-08 at 18 13 41](https://github.com/user-attachments/assets/30d9aa5b-e01c-4def-934f-d661b1ea3549)|


## UI/UX 피드백
1. UI/UX 디자인을 할 때는 이 앱을 통해 전달해야 할 정보의 우선순위를 먼저 생각해야 한다.
2. 우선순위가 큰 순으로 사용자에게 보여주는 비율이 커야한다.
3. 지금 가장 중요한 기능은 지효성 인슐린의 당일 투여 여부를 확인 하는 것
4. 그 다음은 속효성 인슐린의 투여 기록

## 개선할 사항
### 메인 페이지
1. 메인 화면에서 보여주어야 할 정보는 오늘 날짜
2. 지효성 인슐린의 투여 여부 및 안맞은 경우 투여 확인 버튼
3. 속효성 인슐린의 투여 기록 및 투여 확인 버튼

### 세팅 페이지
1. 지효성, 속효성 인슐린을 하나씩 고를 수 있게 수정하기

### 위젯
1. 오늘 날짜와 지효성 인슐린인 경우 오늘 맞았으면 버튼 없이 나오게, 안맞았으면 버튼 누를 수 있게
2. 속효성 인슐린의 경우 버튼을 누르면 기본 설정량으로 기록 추가, 다른 곳을 누르면 속효성 인슐린 투여 페이지로 이동

