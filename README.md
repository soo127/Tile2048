# Tile2048 🟨

간단한 2048 게임 앱으로, 플레이어가 게임을 진행할 보드의 크기를 선택할 수 있습니다.

## 🔍 프로젝트 개요
이 앱은 유명한 게임인 2048을 직접 구현해보고자 제작된 SwiftUI 기반 게임 앱입니다.
알고리즘 문제 풀이 사이트에서 2048 게임에서의 타일 스와이프 로직을 구현하는 문제가 있었는데, 이 문제가 재미있기도 했고 제 기억에 남았습니다. 따라서 이를 확장해서, 앱을 만들어보고자 하였습니다.

## 스킬
- SwiftUI
- TCA (가장 기본적인 내용만 학습 및 사용하였습니다.)
- UserDefault
- SwiftLint

### TCA

2048은 간단한 게임이지만, 저는 게임에서의 로직은 조금 복잡한 면이 있다고 느꼈습니다.
스와이프 → 병합 → 점수 갱신 → 랜덤 타일 생성의 로직이 매번 수행되어야 하고, 게임 종료 여부도 매번 체크해야 하기 때문입니다.
이후 TCA가 이러한 흐름을 효과적으로 구조화하게 도와준다는 것을 알게 되고, 이를 활용해보기로 결정하였습니다.

## 시작화면

- 시작화면은, 플레이어가 게임을 진행할 보드의 크기를 선택할 수 있는 화살표와 게임 시작 버튼이 표시됩니다.

![Simulator Screen Recording - iPhone 17 Pro - 2025-12-08 at 17 21 21](https://github.com/user-attachments/assets/5c660b60-410b-46a8-96b8-bb4085a09f96)

## 게임화면

- 플레이어가 선택한 크기의 보드를 기준으로 게임이 시작됩니다.
- 게임 시작 시, 기본 블럭(2점)이 무작위에 배치됩니다.
- 동서남북 4방향으로 스와이프하여, 존재하는 모든 블럭을 해당 방향으로 밀 수 있습니다.
- 블럭을 밀면서 같은 점수의 블럭이 맞닿는다면, score에 점수가 반영되고 점수가 2배인 하나의 블럭으로 합쳐집니다.

- 각 블럭이 가진 점수마다 배경 색을 다르게 설정하였습니다.
- 타일 점수는 2, 4, 8, 16... 같이 2의 제곱수이므로, log2를 씌워서 해당 값에 따라 블럭의 배경색을 설정하였습니다.

- 스와이프를 진행한 후, 새로운 기본 블럭(2점)이 하나 추가됩니다.
- 다만 (스와이프)와 (새로운 블럭이 추가되는 것)이 동시에 일어난다면, 플레이어 입장에서 어색함을 느낄 수 있음을 확인하였습니다.
- 따라서 스와이프를 진행한 후, 약간의 텀(0.1초)을 두고 새로운 블럭이 추가됩니다.
  
![Simulator Screen Recording - iPhone 17 Pro - 2025-12-08 at 17 24 19](https://github.com/user-attachments/assets/a48d6610-f59f-44c9-82bf-b2e9d503373a)
![Simulator Screen Recording - iPhone 17 Pro - 2025-12-08 at 17 32 07](https://github.com/user-attachments/assets/52dfb1ec-2aa3-4e7e-afa0-23ff8860c419)


- 우측의 리셋 버튼을 누르면, 최고 점수를 업데이트한 후 게임을 재시작합니다.
- 좌측의 홈 버튼을 누르면, 최고 점수를 업데이트한 후 시작화면으로 이동합니다.

![Simulator Screen Recording - iPhone 17 Pro - 2025-12-08 at 17 25 50](https://github.com/user-attachments/assets/4953ae75-fae5-4cfd-ad71-a90773238ee3)


- 각 보드의 크기(2~6으로 설정)마다 BEST 점수는 각각 다르게 관리됩니다.
- 매 스와이프마다, 게임 종료 여부를 확인합니다.
- 게임 종료는 더 이상 보드에 타일을 추가할 수도, 스와이프로 타일을 합칠 수도 없는 경우입니다.
- 게임이 종료되면, 최고 점수를 업데이트한 후 게임을 재시작합니다.

![Simulator Screen Recording - iPhone 17 Pro - 2025-12-08 at 17 32 56](https://github.com/user-attachments/assets/c164fd2f-e0e0-4343-9f0e-f224cceecc9d)

---

## 구조 설계

### TCA

```swift
@Reducer
struct BoardFeature {
@ObservableState
    struct State: Equatable {
        /* ... */
    }

    enum Action {
        /* ... */
    }

    var body: some Reducer<State, Action> {
        /* ... */
    }
}
```
Reducer는 State와 Action을 받아 State를 업데이트합니다.
해당 구조체는 State와 Action, 이들을 받아 새로운 State와 Effect를 반환하는 함수를 정의합니다.


```swift
@ObservableState
struct State: Equatable {
    var board: Board
    var score: Int = 0
    var high: Int = 0
    var gameOver: Bool = false
}

```
State를 통해 게임에서의 상태를 한 곳에서 관리합니다.

```swift
enum Action {
    case swiped(Direction)
    case addRandomTile
    case tileAdded(row: Int, col: Int, value: Int)
    case onAppear
    case resetGame
    case setGameOver(Bool)
}
```
Action을 통해 게임에서 발생하는 로직을 정의합니다.


```swift
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .swiped(direction):
                /* ... */
                return .run { send in
                    try await Task.sleep(for: .milliseconds(100))
                    await send(.addRandomTile)
                }

            case .addRandomTile:
                /* ... */
                return .send(.tileAdded(row: pos.row, col: pos.col, value: Constants.defaultValue))

            case let .tileAdded(row, col, value):
                /* ... */
                return .none

            case .onAppear:
                /* ... */
                return .send(.addRandomTile)

            case .resetGame:
                /* ... */
                return .none

            case let .setGameOver(isPresented):
                /* ... */
                return .concatenate(
                    .send(.resetGame),
                    .send(.addRandomTile)
                )
            }
        }
    }
```
body 내에서 Reduce 클로저를 사용하여, 들어온 Action을 기반으로 State를 변경하고 필요한 Effect를 반환하는 실제 로직을 정의합니다.
Effect는 비동기 작업 등의 Side Effect를 State 관리 로직과 분리하기 위해 존재합니다.


```swift
struct BoardView: View {
    var store: StoreOf<BoardFeature>

    var body: some View {
        // 활용 예제
        // scoreBox(title: "SCORE", value: store.score)
        // store.send(.resetGame)
    }
```
Store은 State를 보관하고, Action을 Reducer에게 전달하며 Reducer의 결과를 UI에게 뿌리는 역할을 합니다.

