# 전력망을 둘로 나누기 - DFS 완전탐색 풀이 (재귀)

Solution1(BFS)과 동일한 완전탐색 전략을 사용하지만, **DFS 재귀**로 구현합니다.
재귀 함수가 **서브트리의 노드 수를 반환**하는 구조가 핵심입니다.

---

## 1. BFS와 무엇이 다른가?

| | Solution1 (BFS) | Solution2 (DFS) |
|--|--|--|
| 탐색 방식 | Queue + 반복문 | 재귀 호출 |
| 카운트 방법 | `count++` 반복 | 재귀 반환값 누적 |
| 코드 길이 | 조금 더 김 | 더 짧고 간결 |
| 스택 오버플로 | 없음 | n≤100이므로 안전 |

핵심 아이디어(`|2k-n|` 공식, 끊은 전선 무시)는 완전히 동일합니다.

---

## 2. DFS 재귀의 핵심: 반환값 활용

BFS에서는 노드를 방문할 때마다 `count++`로 개수를 셌습니다.
DFS 재귀에서는 **각 호출이 자신의 서브트리 크기를 반환**합니다.

```
dfs(노드) = 1(자기 자신) + dfs(자식1) + dfs(자식2) + ...
```

이 패턴은 트리에서 서브트리 크기를 구하는 전형적인 방식입니다.

---

## 3. 알고리즘 단계

```
1. 인접 리스트로 그래프 구성
2. 각 전선(wire)에 대해:
   a. visited 배열 초기화
   b. dfs(1, wire[0], wire[1]) 호출 → 1번 그룹 크기 k 반환
   c. |2k - n| 을 answer와 비교하여 최솟값 갱신
3. answer 반환
```

---

## 4. 코드 설명

```java
public int solution(int n, int[][] wires) {
    int answer = n;
    graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) graph.add(new ArrayList<>());
    for (int[] wire : wires) {
        graph.get(wire[0]).add(wire[1]);
        graph.get(wire[1]).add(wire[0]);
    }

    for (int[] wire : wires) {
        visited = new boolean[n + 1];          // 전선마다 visited 초기화
        int count = dfs(1, wire[0], wire[1]);  // 1번 노드에서 DFS 시작
        answer = Math.min(answer, Math.abs(2 * count - n));
    }
    return answer;
}
```

```java
private int dfs(int curr, int cut1, int cut2) {
    visited[curr] = true;
    int count = 1;  // 현재 노드 자신을 1로 시작

    for (int next : graph.get(curr)) {
        if (!visited[next]
            && !(curr == cut1 && next == cut2)   // 끊을 전선 방향 1 차단
            && !(curr == cut2 && next == cut1)) { // 끊을 전선 방향 2 차단
            count += dfs(next, cut1, cut2);  // 자식 서브트리 크기 누적
        }
    }
    return count;  // 내 서브트리(나 포함) 총 노드 수
}
```

---

## 5. DFS 호출 흐름 시각화

전선 `[4,7]`을 끊는 경우 (n=9, 예시 1):

```
트리 구조:
  1 - 3 - 4 - 5
      |   |
      2   6
          |
          7 - 8    ← [4,7] 끊음
              |
              9
```

```
dfs(1, 4, 7)
 └── → dfs(3, 4, 7)            [3 탐색]
        ├── → dfs(2, 4, 7)     [2 탐색] → 리턴 1
        └── → dfs(4, 4, 7)     [4 탐색]
               ├── → dfs(5, 4, 7) → 리턴 1
               ├── → dfs(6, 4, 7) → 리턴 1
               └── next=7: cut1==curr(4), cut2==next(7) → 차단!
               ↑ 리턴 1+1+1 = 3
        ↑ 리턴 1+1+3 = 5
 ↑ 리턴 1+5 = 6

count = 6
|2×6 - 9| = |12 - 9| = 3
```

---

## 6. 재귀 vs 반복 (BFS) 선택 기준

| 상황 | 추천 |
|------|------|
| n이 작고 코드 간결성이 중요 | DFS 재귀 |
| n이 크거나 스택 오버플로 우려 | BFS 반복 |
| 면접/코테 기본 패턴 연습 | DFS 재귀 (트리 크기 계산 패턴) |

이 문제는 `n ≤ 100`이므로 재귀 깊이가 최대 100 수준이라 DFS 재귀가 안전합니다.

---

## 7. 복잡도 분석

| 항목 | 복잡도 |
|------|--------|
| 시간 | O(n²) — 전선 n-1개 × DFS O(n) |
| 공간 | O(n) — 그래프 + visited + 재귀 스택 |

---

## 8. 예시 검증

| 입력 | 기대 출력 | 확인 |
|------|-----------|------|
| n=9, wires=[[1,3],[2,3],[3,4],[4,5],[4,6],[4,7],[7,8],[7,9]] | 3 | [4,7] 끊기: 6 vs 3 |
| n=4, wires=[[1,2],[2,3],[3,4]] | 0 | [2,3] 끊기: 2 vs 2 |
| n=7, wires=[[1,2],[2,7],[3,7],[3,4],[4,5],[6,7]] | 1 | [2,7] 끊기: 3 vs 4 |
