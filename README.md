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
### 메인 페이지
1. 메인 화면에서 보여주어야 할 정보는 오늘 날짜
2. 지효성 인슐린의 투여 여부 및 안맞은 경우 투여 확인 버튼
3. 속효성 인슐린의 투여 기록 및 투여 확인 버튼

### 세팅 페이지
1. 지효성, 속효성 인슐린을 하나씩 고를 수 있게 수정하기

### 위젯
1. 오늘 날짜와 지효성 인슐린인 경우 오늘 맞았으면 버튼 없이 나오게, 안맞았으면 버튼 누를 수 있게
2. 속효성 인슐린의 경우 버튼을 누르면 기본 설정량으로 기록 추가, 다른 곳을 누르면 속효성 인슐린 투여 페이지로 이동

## 현재 완성된 작업
1. UI피드백 받은 모양으로 메인 페이지 변경
2. 인슐린을 등록하는 기능
3. 인터랙티브 위젯으로 선택한 인슐린의 기록을 추가하는 기능
4. 위젯에서 당일 인슐린 투여 여부로 버튼 표시가 바뀌는 기능
5. lockscreen에서 사용할 수 있는 인터렉티브 위젯 추가

## 해야할 기능
1. 인슐린 투여 기록을 컬렌더 형식으로 보여 줄 수 있도록 할 예정
2. lockScreen Widget은 현재 인슐린을 선택할 수 없기 때문에 수정 예정
3. 인슐린 설정하는 뷰를 없앴기 때문에 새로 만들 예정
4. 앱 내부에서 투여 버튼을 누를 때 투여량을 바꿀 수 있도록 수정 예정
