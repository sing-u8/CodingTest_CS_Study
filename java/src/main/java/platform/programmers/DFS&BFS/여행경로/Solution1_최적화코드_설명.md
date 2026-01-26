### 💻 ArrayList를 활용한 최적화 코드 (Java)

```java
import java.util.*;

class Solution {
    boolean[] visited;
    List<String> answer; // 최종 정답을 저장할 리스트

    public String[] solution(String[][] tickets) {
        // 1. 티켓 정렬 (알파벳 순서 앞서는 경로 우선 탐색을 위해)
        Arrays.sort(tickets, (a, b) -> {
            if (a[0].equals(b[0])) return a[1].compareTo(b[1]);
            return a[0].compareTo(b[0]);
        });

        visited = new boolean[tickets.length];
        
        // 탐색용 현재 경로 리스트 생성
        ArrayList<String> currentPath = new ArrayList<>();
        currentPath.add("ICN"); // 시작점 미리 추가

        dfs("ICN", tickets, currentPath);

        // List<String>을 String[] 배열로 변환하여 반환
        return answer.toArray(new String[0]);
    }

    public boolean dfs(String now, String[][] tickets, List<String> currentPath) {
        // 기저 조건: 경로에 담긴 도시 수가 (티켓 수 + 1)이면 모든 티켓을 사용한 것임
        if (currentPath.size() == tickets.length + 1) {
            // 주의: currentPath는 계속 변하므로, 현재 상태를 복사해서 저장해야 함!
            answer = new ArrayList<>(currentPath);
            return true;
        }

        for (int i = 0; i < tickets.length; i++) {
            // 현재 공항(now)에서 출발하고, 아직 사용 안 한 티켓 찾기
            if (!visited[i] && tickets[i][0].equals(now)) {
                
                // [상태 변경]
                visited[i] = true;
                currentPath.add(tickets[i][1]); // 리스트에 목적지 추가

                // [재귀 호출]
                if (dfs(tickets[i][1], tickets, currentPath)) {
                    return true; // 정답 찾으면 즉시 종료
                }

                // [백트래킹 - 상태 복구] ★ 가장 중요한 부분 ★
                // 방금 넣었던 목적지를 다시 뺍니다. (마지막 인덱스 삭제)
                currentPath.remove(currentPath.size() - 1);
                visited[i] = false;
            }
        }

        return false;
    }
}

```

---

### 🔍 변경된 점과 핵심 포인트

기존 `String` 방식과 비교했을 때 무엇이 달라졌는지 확인해 보세요.

#### 1. 상태 관리 방식 (State Management)

* **기존 (String):** `dfs(..., route + " " + next)`
* 새로운 문자열을 계속 만들어내므로 별도의 복구 과정이 필요 없었습니다. (편하지만 느림)


* **변경 (ArrayList):**
* **추가:** `currentPath.add(tickets[i][1]);`
* **복구:** `currentPath.remove(currentPath.size() - 1);`
* **이유:** `currentPath` 리스트 하나를 재귀 함수들이 **공유**하기 때문에, 내가 탐색을 마치고 나올 때는 반드시 **내가 추가했던 도시를 지워줘서** 이전 상태로 돌려놓아야 합니다.



#### 2. 정답 저장 (Deep Copy)

* 코드 중간에 `answer = new ArrayList<>(currentPath);` 부분이 있습니다.
* 만약 그냥 `answer = currentPath;`라고 하면 안 됩니다. `currentPath`는 백트래킹 과정에서 계속 요소가 지워지기 때문에, 결국 빈 리스트가 되어버릴 수 있습니다. **정답을 찾은 그 순간의 스냅샷(복사본)을 저장**해야 합니다.

#### 3. 효율성 (Efficiency)

* **시간:** 문자열을 복사하는  비용이 사라지고, 리스트의 끝에 추가/삭제하는  연산만 남게 되어 훨씬 빠릅니다.
* **공간:** 불필요한 문자열 객체 생성이 사라져 메모리 사용량이 대폭 감소합니다.

### 💡 StringBuilder는 안 쓰나요?

`StringBuilder`도 사용 가능하지만, 이 문제에서는 **`ArrayList`가 더 유리**합니다.

* `StringBuilder`는 문자열(`"ICN,ATL,..."`)을 다루기 때문에, 마지막 공항을 지우려면 쉼표(`,`) 위치를 찾거나 글자 수를 계산해서 `delete` 해야 하므로 코드가 지저분해집니다.
* `ArrayList`는 "공항" 단위로 깔끔하게 관리할 수 있어 구현 실수를 줄여줍니다.

이 코드로 제출하시면 훨씬 효율적이고 "알고리즘 정석"에 가까운 풀이가 됩니다. 이해가 잘 되셨나요? 😊