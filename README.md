# 은행창구매니저

>프로젝트 기간 2022-04-25 ~ 2022-05-06
>
>팀원 : [Taeangel](https://github.com/Taeangel), [Tiana](https://github.com/Kim-TaeHyun-A) / 리뷰어 : [엘림](https://github.com/lina0322)

## 개발환경 및 라이브러리
[![swift](https://img.shields.io/badge/swift-5.6-orange)]()
[![xcode](https://img.shields.io/badge/Xcode-13.3.1-blue)]()
[![SwiftLint](https://img.shields.io/badge/SwiftLint-green)]()

# 학습한 키워드
`concurrency programming` `GCD` `Operation` `delegate pattern` `observer pattern`

## PR 바로가기
[STEP 1 PR](https://github.com/yagom-academy/ios-bank-manager/pull/146)

[STEP 2 PR](https://github.com/yagom-academy/ios-bank-manager/pull/156)

[STEP 3 PR](https://github.com/yagom-academy/ios-bank-manager/pull/170)

---

# STEP1
1. linked list

* 시간복잡도
append 할 때 tail이 없으면 매번 제일 마지막 노드를 찾아가야 하지만(O(n)) tail이 있으면 바로 값을 추가할 수 있기에 시간 복잡도가 O(1)이 됩니다.

* 접근제어자
LinkedList가 클래스 타입이고 Queue 타입이 생성될 때 꼭 가져야 하며 외부에서 접근 못하도록 하기 위해 private let으로 기본값이 존재하는 프로퍼티를 만들었습니다.
LinkedList는 클래스로 선언된 타입입니다. 이를 이니셜라이져에서 전달해서 초기화를 진행하면 외부에서도 해당 프로퍼티에 접근이 가능합니다. 그러면, private으로 선언한 의미가 없어지는 것 같습니다.
LinkedList가 구조체라면 이니셜라이져나 메서드를 사용해서 외부에서 넣어주는 것이 좋을 것 같습니다.

* Node의 파일 위치
Node가 해당 파일에서만 사용될 것으로 예상하여 동일한 파일에 위치시켰습니다.

2. SwiftLint
들여쓰기가 된 상태에서 줄바꿈을 하면 앞에 자동으로 들여쓰기가 되는데 이때 오류 메시지가 나오지 않게 하기 위해 trailing_whitespace에 대해 무시하도록 rule을 설정했습니다.
comment_spacing의 룰 추가로 주석에서 띄어쓰기에 대한 에러를 무시합니다.
redundant_discardable_let의 룰 추가로 메서드의 반환한 값이 사용되지 않은 경우 _에 값을 할당하는 것을 허용합니다.
.gitignore에 /pods를 작성해서 불필요한 커밋 내역을 깃에서 추적하지 않도록 했습니다.

3. UnitTest
command line tool 프로젝트여서 @testable을 사용해서 외부 모듈을 import할 수 없었습니다.
따라서, 프로젝트 설정에서 target 추가로 unitTest bundle을 추가했습니다.
인스펙터 창에서 target membership을 직접 세팅했습니다.(Queue와 LinkedList 파일이 Test 모듈을 타겟으로 설정하도록 했습니다.)

4. scheme
unit test를 실행할 때 scheme이 QueueTest여야 테스트가 가능합니다.
scheme을 BankManagerConsoleApp으로 바꾸면 swiftlint rule이 적용됩니다.


5. final 키워드
final은 상속을 막는다는 것을 명시적으로 표기하기 위해 사용했습니다.
또 static dispatch가 되어 빌도 속도가 향상될 수 있습니다.
하지만, Xcode build setting에서 swift compiler에 기본값으로 Whole Module Optimization이 설정되어서 overriding하지 않는 것에 컴파일러가 자동으로 final을 붙여준다고 합니다.
따라서, final이라고 명시하는 것은 가독성이 주된 이유가 되는 것 같습니다.

6. 구조체 vs 클래스
Node의 next 프로퍼티 때문에 Node는 클래스 타입이어야하고, Linked List가 구조체여도 heap 할당이 생깁니다. 그리고 LinkedList의 대부분이 mutating 메서드가 됩니다. 반면, Queue의 경우는 메서드에서 프로퍼티의 값 변경하지 않아서 구조체로 사용하는 것이 더 좋다고 생각했습니다.

---

# STEP2

### 고민한 점

1. Node 파일 이동 대신 private 으로 설정
enqueue할 때 Node를 알 필요가 없다고 판단해서 LinkedList의 append 메서드의 매개변수와 내부에서 Node를 생성하도록 수정했습니다.
Node가 사용되는 곳이 LinkedList 뿐이어서 Node 타입을 private으로 접근 제어자를 수정했습니다.

2. 하드 코딩 지양
처음에는 nested type으로 Constant를 만들어서 사용했습니다.
그런데, 이 타입이 정의된 목적은 하드 코딩을 하지 않는 것뿐이고 외부에서 사용되지 않을 것 같아서 private으로 타입의 접근제어자를 설정하고 기존에 있던 타입의 외부로 위치를 위동시켰습니다.

3. sync vs async, global vs main
bank가 영업을 종료했을 때 실행해야하는 것을 제대로 기다리지 못해서 발생한 문제입니다. 따라서, group으로 async로 구문을 실행시키고 wait해서 완료되기를 기다리면 될 것 같습니다.
async는 실행이 완료되는 것을 기다리지 않고 이후 명령어를 실행하지만 sync는 완료되기를 기다리는 것으로 알고 있습니다.
완료되기를 기다리기에 block된다고 볼 수 있을 것 같습니다.

main.sync의 경우 deadlock이 발생해서 사용할 수 없습니다.
작업이 끝나기를 기다리는 sync의 특성 때문에 Block-wait가 발생한다고 합니다.
main 스레드는 sync가 끝나기를, sync는 main 스레드의 Block-wait이 끝나기를 기다리는 상태가 되어서 deadlock이 생깁니다.
따라서, 어떤 명령어도 수행되지 못하는 상태가 됩니다.


4. 소수점 내림
```swift
extension Double {
    var formatSecondDecimal: String {
        return String(format: "%.2f", floor(self * 10) / 10 )
    }
}
```
Double을 extension해서 연산 프로퍼티로 원하는 형태로 값이 나오도록 구현했습니다.
직원이 일을 하는 매서드(work)에서 0.7초 동안 sleep을 하도록 했습니다.
이때, 은행 업무 시간 중(bank.open이후) 직원이 print문을 실행하는 등의 다른 부수적인 일을 진행해서 `0.7 X 반복 횟수` 만큼 나오지 않습니다.
따라서, 불필요한 값을 버리기 위해 소수점 한자리에서 내림을 하도록 10을 곱하고 floor 매서드를 통해 내림을 진행하고 다시 10을 나누는 것으로 해결했습니다.

5. String extension
```swift
extension String {
    static var empty: Self {
        return ""
    }
}
```
기본 타입인 String과 연관된 문자열의 case로 처리하기보다는 extension에서 연산 프로퍼티로 구현했습니다.

6. 프로퍼티의 기본값 vs 이니셜라이저에서 주입
"꼭 필요한 값의 경우인가 외부에서 생성해서 넣어주는 것이 적절한 경우인가" 에 대해 고민하여 선택하였습니다.
Bank의 경우 꼭 client를 가지는 것이 적절해 보여 기본값으로 할당하고, BankManger의 경우 Bank를 주입하도록 해서 유연한 코드 작성이 가능한 것 같습니다.

7. Array의 index로 안전하게 접근하기
기본 프로퍼티로 제공되는 first, last를 사용하면 nil을 반환하기 때문에 run time error가 생기는 것을 막을 수 있습니다.
그 이외 요소에 접근하는 경우 아래와 같이 코드를 작성하면 안전하게 접근이 가능합니다.

```swift
extension Array {
  subscript(safe index: Int) -> Element? {
    return self.indices ~= index ? self[index] : nil
  }
}
```

8. struct vs class
모든 스레드는 자신만의 stack을 가지고 있기 때문에 구조체는 thread-safe 하지만 클래스는 그렇지 않습니다.
stack에서의 allocation과 deallocation은 메모리에서 stack pointer의 이동만 일어나서 cost가 작습니다.
참조타입의 경우 scope 외부에서도 살아있기에 참조값 관리가 필요하고 컴파일 타임에 메모리 사이즈 확인이 힘들어서 heap allocation이 됩니다.
상황에 따라 다른 것 같지만 쓰레드에서의 안전성이나 컴파일 측면에서 보면 일반적으로 구조체를 사용하는 것이 더 좋을 것 같습니다.


9. 상수 프로퍼티
Client의 경우 고객이 생성될 때 고유 번호를 반드시 가지고 있고 추후 변경되지 않을 것이라고 생각해서 상수 프로퍼티로 구현했습니다.

---

# STEP3
clerks라는 은행원집단을 만들고 세마포어 value값을 조절해서 구현하는 방식입니다.

[직원 한명이 하나의 queue를 가지고, 은행 매니저가 직원들에게 분배해주는 방식으로 수정한 구현](https://github.com/yagom-academy/ios-bank-manager/commit/9e34b4d373e6a149ef80010a7423ae2f257d517c)

1. BankClerk
step2에서 배열로 정의했던 은행 직원을 쓰레드로 변경했습니다.
세마포어(S = S-1 ⇒ S를 0로 만들어 다른 프로세스가 들어 오지 못하도록 함 -> 내부 수행이 끝나면 S를 증가시킴)를 사용해서 비동기 스레드를 돌리는 스레드의 개수를 제어하려고 했습니다.


2. notify vs wait
notify의 command line tool에서 사용하면 제대로 동작하지 않는 것 같습니다.
notify와 wait/signal을 비교하면 notify는 그룹이 끝나기를 기다렸다가 대기 중이던 비동기 그룹들이 다 끝나면 원하는 작업을 수행합니다.(notify 대신에 group.wait()을 작성하고 다음 명령어로 원하는 작업을 작성해도 되는 것을 알고 있습니다.) wait/signal의 경우 세마포어의 value를 변경하여 접근 가능한 스레드 개수를 조절합니다.


3. 스레드 중간에 return이 있는 경우의 문제점
만약 semaphore.wait(), semaphore.signal() 중간에(쓰레드 중간에) return이 있으면 영업 시간이 부족하게 나옵니다.
return 이후 명령어 수행하지 않고 실행 중이던 모든 모든 스레드가 바로 반환 → 진행 중이던 스레드도 아래 명령어 수행 않고 같이 종료되는 듯 → defer{ } 안에 넣으면 수행하는 것으로 보임(이유: 메서드 종료 직전에 꼭 수행하는 부분)

4. 타입 역할 구분
bankmanager와 bank의 기능을 명확히 구별하기가 애매하였습니다. 그래서
bank의 운영과 가이드와 같은 기능을 bankmanager로 분리했고 은행업무와 같은 기능은 bank로 분리하고 그에 맞게 네이밍을 했습니다.
그러나 bankmanager를 보면 사용자에게 메뉴를 입력받고 전체 프로그램을 관리하는 역할이어서 일반적인 은행의 관리자와는 다른 역할을 가지고 있다고 생각되어 그에 맞게 네이밍을 다시 변경했습니다.

5. Measureable 프로토콜
시간 측정하는 메서드를 프로토콜의 extension에 정의했지만, 프로토콜의 메서드가 시간을 측정하기 위해 은행을 open하는 느낌을 줘서(bank.open이 아니라 measureTime메서드를 호출해서) 구현한 메서드를 제거했습니다.

6. 동일한 case를 가지는 타입 처리
연산 프로퍼티를 사용해서 switch문으로 매칭되는 값을 return 하도록 구현했습니다.

7. fileprivate
private이 타입에 붙으면 fileprivate처럼 사용이 가능하지만 좀더 의미를 명확히 하기위해 fileprivate이 적합해 보입니다.

---

# STEP4
1. GCD를 Operation로 변경
기존 dispatchQueue에서는 대기열에 있는 작업들을 cancel 할 수 없는 문제가 발생하여 현제 실행되고 있는 작업을 제외한 모든 작업들을 cancel 할 수 있는 operationQueue로 로직을 변경하였습니다.


2. 코드로 UI 구현하기

stackView를 적극 활용하여 각종 UIView들의 위치를 잡아주었고 UIView 프로터티안에 알맞는 값을 넣어주는 방식으로 UIView를 구현하였습니다.

viewController와 view의 역할을 구분하기 위해서 view 클래스를 따로 만들고 viewController의 root view에 할당하도록 구현했습니다.

3. Timer
아래 코드를 사요해서 main run loop에 timer를 추가해서 스크롤 뷰에서 스크롤해서 timer가 멈추가 않고 동작하도록 구현했습니다.
```swift
RunLoop.main.add(timer, forMode: .common)
```

4. 프레임워크
외부 모듈을 들고오기 위해서 프로젝트 세팅 General 메뉴에서 framework로 외부에 정의된 모델을 가져왔습니다.
![](https://i.imgur.com/PSCSqIF.png)


5. dateFormattter
```swift
extension DateFormatter {
    static var fomat: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss:SSS"
        return dateFormatter
    }
}

```


```swift
func calculateTime() -> String {
        guard let convertedInitTime: Date = dateFormatter.date(from: initTime) else {
            return ""
        }
        
        let newTime = convertedInitTime + time
        
        return dateFormatter.string(from: newTime)
}
```
위 코드를 사용해서 원하는 형식의 dateFormat을 구현하고 Date과 Double을 연산해서 시간 계산을 진행했습니다.

6. delegate Pattern
은행 업무 전후에 처리할 것을 위임하기 위해 델리게이트 패턴을 사용했습니다.

```swift
protocol BankDelegate {
    func startClerkProcess(client: Client)
    func completeClerkProcess(client: Client)
}

extension BankViewController: BankDelegate {
    func startClerkProcess(client: Client) {
        stopWatch.start()
        let processingNumber = client.waitingNumber - 1
        guard let processingClient = waitingClients[safe: processingNumber] else {
            return
        }
        removeStack(of: client, in: baseView.waitingClientStackView)
        addStack(client: processingClient, in: baseView.processingClientStackView)
    }
    
    func completeClerkProcess(client: Client) {
        removeStack(of: client, in: baseView.processingClientStackView)
    }
}
```

```swift
bank.bankDelegate = self

```

```swift 

 var bankDelegate: BankDelegate?

```


7. observer Pattern
타이머의 시간이 갱신됨에 따라 타이머 레이블의 text를 업데이트하기 위해 옵저버 패턴을 사용했습니다.

```swift
protocol Observer {
    func updateLabel()
}

extension BankViewController: Observer {
    func updateLabel() {
        baseView.timeLabel.text = stopWatch.calculateTime()
    }
}

extension StopWatch {
    func subscribe(observer: Observer) {
        self.observer = observer
    }
    
    func unSubscribe(observer: Observer) {
        self.observer = nil
    }
    
    private func notify() {
        observer?.updateLabel()
    }
}

final class BankViewController: UIViewController {
    @objc private func didTapaddClientsButton() {
        stopWatch.subscribe(observer: self)
        ...
    }
    
    @objc private func didTapResetBankButton() {
        stopWatch.stop()
        stopWatch.unSubscribe(observer: self)
        ...
    }
    ...
}
```



