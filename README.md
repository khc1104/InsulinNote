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
2. 우선순위가 큰 순으로 사용자에게 보여주는 비율이 커야한다.
3. 지금 가장 중요한 기능은 지효성 인슐린의 당일 투여 여부를 확인 하는 것
4. 그 다음은 속효성 인슐린의 투여 기록

## 개선할 사항
### 위젯
1. 오늘 날짜와 지효성 인슐린인 경우 오늘 맞았으면 버튼 없이 나오게, 안맞았으면 버튼 누를 수 있게
2. 속효성 인슐린의 경우 버튼을 누르면 기본 설정량으로 기록 추가, 다른 곳을 누르면 메인 뷰로 이동

## 현재 완성된 작업
1. 메인 뷰
2. 인슐린 설정 뷰
3. 달력 뷰
4. 홈스크린 위젯에서 지효성 인슐린 기록하는 기능
5. 락스크린에서 지효성 인슐린 투여 기록하는 기능

## 해야할 기능
1. 앱 내부에서 투여 버튼을 누를 때 투여량을 바꿀 수 있도록 수정
2. 속효성 인슐린은 위젯에서 하루에 여러번 누를 수 있게 구현
3. lockScreen Widget 편집시 인슐린 선택할 수 있도록 수정
4. 
