안녕하세요! 이번 문제는 코딩 테스트에서 매우 자주 등장하는 **완전 탐색(Brute Force)** 유형의 대표적인 문제입니다.

문제를 해결하기 위해서는 크게 두 가지 단계가 필요합니다.

1. **조합 만들기 (순열)**: 종이 조각을 붙여서 만들 수 있는 **모든 가능한 숫자**를 다 만들어본다.
2. **소수 판별**: 만들어진 숫자가 **소수(Prime Number)**인지 확인하고 개수를 센다.

---

## 1. 핵심 전략: DFS로 모든 숫자 만들기

종이 조각이 "1", "7" 두 장 있다고 가정해 봅시다.
우리는 이 조각들로 다음과 같은 과정을 거쳐 숫자를 조합할 수 있습니다.

1. **한 자리 수**: 1, 7
2. **두 자리 수**: 17, 71
3. 이때, `Set` 자료구조를 사용하면 중복된 숫자(예: "011"과 "11")를 자동으로 하나로 합칠 수 있습니다.

---

## 2. 다국어 솔루션 코드

사용자님이 주력으로 공부하시는 **Java**를 메인으로 하고, JavaScript와 C++ 코드도 함께 준비했습니다.

### Java (재귀 함수 + HashSet)

```java
import java.util.HashSet;

class Solution {
    // 중복을 제거하기 위해 HashSet 사용
    HashSet<Integer> numberSet = new HashSet<>();

    public int solution(String numbers) {
        // 1. 모든 조합의 숫자를 만든다 (재귀 함수 호출)
        recursive("", numbers);

        // 2. 소수의 개수를 센다
        int count = 0;
        for (int num : numberSet) {
            if (isPrime(num)) {
                count++;
            }
        }
        return count;
    }

    // 재귀적으로 숫자를 만드는 함수 (순열)
    // comb: 현재까지 조합된 숫자 문자열
    // others: 아직 사용하지 않은 남은 종이 조각들
    public void recursive(String comb, String others) {
        // 현재 조합된 문자열이 비어있지 않다면 Set에 추가
        if (!comb.equals("")) {
            numberSet.add(Integer.valueOf(comb));
        }

        // 남은 숫자 조각으로 계속 조합을 이어감
        for (int i = 0; i < others.length(); i++) {
            recursive(comb + others.charAt(i), 
                      others.substring(0, i) + others.substring(i + 1));
        }
    }

    // 소수 판별 함수
    public boolean isPrime(int num) {
        if (num < 2) return false; // 0과 1은 소수가 아님
        
        // 2부터 제곱근까지 나누어 떨어지는지 확인 (효율성 핵심)
        for (int i = 2; i * i <= num; i++) {
            if (num % i == 0) return false;
        }
        return true;
    }
}

```

### JavaScript

```javascript
function solution(numbers) {
    const numberSet = new Set();

    // 1. 순열 만들기 (재귀)
    function makeNumbers(current, remaining) {
        if (current.length > 0) {
            numberSet.add(Number(current));
        }

        if (remaining.length === 0) return;

        for (let i = 0; i < remaining.length; i++) {
            // 현재 숫자를 붙이고, 해당 숫자를 제외한 나머지를 다음 단계로 넘김
            const nextCurrent = current + remaining[i];
            const nextRemaining = remaining.slice(0, i) + remaining.slice(i + 1);
            makeNumbers(nextCurrent, nextRemaining);
        }
    }

    makeNumbers("", numbers);

    // 2. 소수 판별
    function isPrime(num) {
        if (num < 2) return false;
        for (let i = 2; i * i <= num; i++) {
            if (num % i === 0) return false;
        }
        return true;
    }

    // Set의 요소들을 배열로 바꿔서 필터링 후 길이 반환
    return [...numberSet].filter(isPrime).length;
}

```

### C++

```cpp
#include <string>
#include <vector>
#include <set>
#include <cmath>
#include <algorithm>

using namespace std;

set<int> numberSet;

bool isPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i * i <= n; i++) {
        if (n % i == 0) return false;
    }
    return true;
}

void recursive(string comb, string others) {
    if (comb != "") {
        numberSet.insert(stoi(comb));
    }
    
    for (int i = 0; i < others.length(); i++) {
        recursive(comb + others[i], others.substr(0, i) + others.substr(i + 1));
    }
}

int solution(string numbers) {
    numberSet.clear(); // 전역 변수 초기화
    recursive("", numbers);
    
    int answer = 0;
    for (int num : numberSet) {
        if (isPrime(num)) answer++;
    }
    
    return answer;
}

```

---

## 3. 알고리즘 상세 해설

### ① 순열 만들기 (Recursive Function)

이 문제의 가장 어려운 부분입니다. 종이 조각이 `[1, 7]`이라면:

1. 맨 앞자리에 `1`을 선택 -> 남은 건 `[7]` -> `1` 뒤에 `7`을 붙임 => `17` 완성
2. 맨 앞자리에 `7`을 선택 -> 남은 건 `[1]` -> `7` 뒤에 `1`을 붙임 => `71` 완성
3. 그냥 `1`만 선택 => `1` 완성
4. 그냥 `7`만 선택 => `7` 완성

이 과정을 코드에서는 **재귀 함수(Recursion)**로 구현했습니다. `others.substring(0, i) + others.substring(i + 1)` 부분은 **방금 사용한 숫자를 제외하고 나머지 숫자들을 추려내는 역할**을 합니다.

### ② 소수 판별의 효율성 ()

소수를 판별할 때 2부터 까지 모두 나누어보면 시간이 너무 오래 걸립니다.
수학적으로 **어떤 수 의 약수는 $\sqrt{N}$을 기준으로 대칭**을 이룹니다. 따라서 **$\sqrt{N}$까지만 확인**해도 소수인지 100% 확신할 수 있습니다.

* 예: 36의 약수 -> 1, 2, 3, 4, 6, 9, 12, 18, 36
* 이므로 6(제곱근)까지만 검사하면 그 뒤는 확인할 필요가 없습니다.
* 코드: `i * i <= num` (이 조건이 $\sqrt{N}$까지 검사한다는 뜻입니다.)

---

### 멘토의 팁 💡

이 문제는 **"재귀 함수를 이용해 조합/순열을 만들 수 있는가?"**를 묻는 전형적인 문제입니다. 처음엔 코드가 복잡해 보일 수 있지만, `recursive` 함수의 패턴(하나 떼고 나머지 넘기기)은 다른 문제에서도 계속 쓰이니 꼭 익혀두시는 것이 좋습니다.

**다음 단계:** 혹시 재귀 함수의 동작 원리가 머릿속에 잘 그려지지 않는다면, **호출 스택(Call Stack)이 쌓이는 과정**을 그림으로 그려서 설명해 드릴까요?

# 4. 호출 스택 트리 설명

가장 간단한 예시인 **`numbers = "17"`**인 경우를 가정하고, 컴퓨터 내부에서 어떤 일이 벌어지는지 **슬로우 모션**으로 보여드리겠습니다.

---

### 1. 전체 지도: 탐색 트리 (Tree)

먼저, 우리가 어떤 순서로 길을 가는지 '지도'를 먼저 봅시다. 코드는 **깊이(Depth)** 우선으로 파고듭니다.

```text
START: recursive("", "17")
 │
 ├── 1. ("1", "7") 선택! ──┐
 │      (Set에 1 저장)     │
 │                       ├── 2. ("17", "") 선택!
 │                       │      (Set에 17 저장)
 │                       │      (더 이상 남은 카드 없음 -> 리턴/POP)
 │                       │
 │                       └─ (1번 경로 끝 -> 리턴/POP)
 │
 └── 3. ("7", "1") 선택! ──┐
        (Set에 7 저장)     │
                         ├── 4. ("71", "") 선택!
                         │      (Set에 71 저장)
                         │      (더 이상 남은 카드 없음 -> 리턴/POP)
                         │
                         └─ (3번 경로 끝 -> 리턴/POP)
 END

```

---

### 2. 호출 스택(Call Stack) 시뮬레이션

이제 실제 메모리(스택)에 함수가 쌓이고 사라지는(Push & Pop) 과정을 단계별로 그립니다.
**상자 안**은 현재 실행 중인 함수(Stack Frame)입니다.

#### [Step 1] 최초 호출

* `main`에서 `recursive("", "17")`을 호출합니다.
* 스택에 첫 번째 함수가 쌓입니다.

```text
|                                     |
|                                     |
| [recursive("", "17")]               | ← i=0 ('1' 선택 예정)
|_____________________________________|

```

#### [Step 2] 첫 번째 조각 '1' 선택 (PUSH)

* `i=0`일 때, '1'을 선택합니다.
* `comb`는 "1", `others`는 "7"이 됩니다.
* **새로운 함수**가 스택 위에 쌓입니다. (기존 함수는 잠시 멈춤)

```text
|                                     |
| [recursive("1", "7")]               | ← 현재 실행 중! (Set에 1 추가)
|-------------------------------------|
| [recursive("", "17")]               | ← 대기 중 (i=0 상태에서 멈춤)
|_____________________________________|

```

#### [Step 3] '1' 뒤에 '7' 선택 (PUSH)

* 위의 함수(`"1", "7"`)에서 다시 `for`문이 돕니다.
* `others`("7")에서 '7'을 선택합니다.
* `comb`는 "17", `others`는 ""(빈 문자열)이 됩니다.
* **또 새로운 함수**가 쌓입니다.

```text
| [recursive("17", "")]               | ← 현재 실행 중! (Set에 17 추가)
|-------------------------------------|   (others가 비었으므로 for문 실행 안 함)
| [recursive("1", "7")]               | ← 대기 중 (i=0 상태)
|-------------------------------------|
| [recursive("", "17")]               | ← 대기 중 (i=0 상태)
|_____________________________________|

```

#### [Step 4] 더 갈 곳이 없다 (POP) - 백트래킹의 시작

* 맨 위 `recursive("17", "")` 함수는 `others`가 없어서 `for`문을 못 돕니다.
* 할 일을 다 마쳤으므로 함수가 종료되고 **스택에서 사라집니다(POP)**.
* 컴퓨터는 바로 아래에 있던 함수로 돌아갑니다.

```text
|           (POP! 사라짐)             | 
|-------------------------------------|
| [recursive("1", "7")]               | ← 다시 실행 재개!
|-------------------------------------|   (아까 i=0 처리 끝났음. 다음 i가 있나?)
| [recursive("", "17")]               | ← 대기 중
|_____________________________________|

```

#### [Step 5] '1' 베이스의 탐색 종료 (POP)

* `recursive("1", "7")` 함수를 봅니다. `others` 길이가 1이라 `i`는 0까지만 돕니다.
* 이 함수도 할 일을 다 마쳤습니다. **스택에서 사라집니다(POP)**.
* 최초의 함수로 돌아갑니다.

```text
|           (POP! 사라짐)             | 
|-------------------------------------|
|                                     |
|-------------------------------------|
| [recursive("", "17")]               | ← 다시 실행 재개!
|_____________________________________|   (아까 i=0('1') 끝냄. 이제 i=1('7') 차례!)

```

#### [Step 6] 두 번째 조각 '7' 선택 (PUSH)

* 이제 `i=1`이 되어 '7'을 선택합니다.
* `comb`는 "7", `others`는 "1"이 됩니다.
* 새로운 역사가 시작됩니다.

```text
|                                     |
| [recursive("7", "1")]               | ← 현재 실행 중! (Set에 7 추가)
|-------------------------------------|
| [recursive("", "17")]               | ← 대기 중 (i=1 상태)
|_____________________________________|

```

*(이후 과정은 Step 3~4와 동일하게 "71"을 만들고 POP 되는 과정을 거칩니다)*

---

### 3. 핵심 요약 (Mental Model)

1. **마트료시카 인형**: 재귀 함수는 자기 자신 안에 또 다른 자신을 넣는 것과 같습니다. 가장 작은 인형(종료 조건, `others`가 빈 문자열)이 나올 때까지 계속 깝니다.
2. **일시 정지**: 새로운 `recursive`를 호출하는 순간, 부모 함수는 그 자리에서 **'일시 정지'** 상태가 됩니다. 자식이 일을 다 끝내고 리턴(POP)해야만 다시 재생 버튼이 눌립니다.
3. **상태 보존**: 스택에 쌓여있던 부모 함수(`recursive("", "17")`)는 자식이 무슨 짓을 하고 돌아오든, 자신의 변수 상태(`i=0`, `others="17"`)를 그대로 기억하고 있습니다. 그래서 '1'로 시작하는 모든 경우를 다 본 뒤에, 잊지 않고 '7'로 시작하는 경우를 따질 수 있는 것입니다.

이 그림이 머릿속에 그려지시나요?
이 개념이 이해되셨다면, **"백트래킹(Backtracking)"**의 절반 이상을 정복하신 겁니다!

혹시 `others.substring`을 사용할 때, 메모리상에서 문자열이 계속 새로 생성되는 것에 대한 효율성이 걱정되진 않으신가요? (이 부분도 코딩 테스트 고득점을 위한 중요한 포인트입니다!)