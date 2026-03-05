# 전력망을 둘로 나누기 - BFS 완전탐색 풀이

이 문제는 **트리에서 전선 하나를 끊어** 두 그룹의 송전탑 수 차이를 최소화하는 전형적인 **완전탐색(Brute Force)** 문제입니다.

---

## 1. 문제 이해

- `n`개의 송전탑이 **트리(사이클 없는 연결 그래프)** 형태로 연결되어 있습니다.
- 전선(`wires`) 중 하나를 끊으면 트리가 **정확히 두 그룹**으로 나뉩니다.
- 모든 전선에 대해 끊었을 때의 두 그룹 크기 차이를 구하고, 그 **최솟값**을 반환합니다.

```
예시 (n=9):
  1 - 3 - 4 - 5
      |   |
      2   6
          |
          7 - 8
              |
              9
```

---

## 2. 핵심 아이디어

### 왜 완전탐색이 가능한가?

- 전선의 수 = `n - 1`개 (트리 성질)
- `n ≤ 100`이므로 최대 99개의 전선만 확인하면 됩니다.
- 전선 하나 제거 후 BFS 탐색: O(n)
- 전체 시간복잡도: O(n²) → 충분히 빠릅니다.

### 한쪽만 세면 되는 이유

전선을 끊으면 두 그룹이 생깁니다. 1번 노드가 속한 그룹의 크기를 `k`라 하면:
- 나머지 그룹 크기 = `n - k`
- 차이 = `|k - (n - k)| = |2k - n|`

즉, **1번 노드에서 BFS로 도달 가능한 노드 수**만 세면 됩니다.

---

## 3. 알고리즘 단계

```
1. 인접 리스트로 그래프 구성
2. 각 전선(wire)에 대해:
   a. 해당 전선을 끊은 것처럼 BFS 수행
   b. 1번 노드에서 도달 가능한 노드 수 k 계산
   c. |2k - n| 을 answer와 비교하여 최솟값 갱신
3. answer 반환
```

---

## 4. 코드 설명

```java
public int solution(int n, int[][] wires) {
    int answer = n;  // 최악의 경우 차이는 n을 넘을 수 없음

    // 인접 리스트 구성 (양방향)
    List<List<Integer>> graph = new ArrayList<>();
    for (int i = 0; i <= n; i++) graph.add(new ArrayList<>());
    for (int[] wire : wires) {
        graph.get(wire[0]).add(wire[1]);
        graph.get(wire[1]).add(wire[0]);
    }

    // 각 전선을 하나씩 끊어보며 BFS 수행
    for (int[] wire : wires) {
        int count = bfs(n, graph, wire[0], wire[1]);  // wire를 끊었을 때 1번 그룹 크기
        answer = Math.min(answer, Math.abs(2 * count - n));
    }
    return answer;
}
```

```java
private int bfs(int n, List<List<Integer>> graph, int cut1, int cut2) {
    boolean[] visited = new boolean[n + 1];
    Queue<Integer> queue = new LinkedList<>();
    queue.add(1); visited[1] = true;
    int count = 0;
    while (!queue.isEmpty()) {
        int curr = queue.poll(); count++;
        for (int next : graph.get(curr)) {
            if (!visited[next]
                && !(curr == cut1 && next == cut2)   // 끊을 전선의 한쪽 방향
                && !(curr == cut2 && next == cut1)) { // 끊을 전선의 반대 방향
                visited[next] = true; queue.add(next);
            }
        }
    }
    return count;  // 1번 노드가 속한 그룹의 크기
}
```

**핵심 조건:** 전선 `(cut1, cut2)`를 실제로 삭제하지 않고, BFS 탐색 중 해당 간선을 **무시(skip)** 합니다. 양방향 간선이므로 두 방향 모두 차단합니다.

---

## 5. 복잡도 분석

| 항목 | 복잡도 |
|------|--------|
| 시간 | O(n²) — 전선 n-1개 × BFS O(n) |
| 공간 | O(n) — 그래프 + visited 배열 |

---

## 6. 예시로 확인 (n=9)

```
wires = [[1,3],[2,3],[3,4],[4,5],[4,6],[4,7],[7,8],[7,9]]
```

전선 `[4,7]`을 끊는 경우:
```
그룹 A (1번 소속): 1-3-2, 3-4-5, 4-6  → 6개
그룹 B: 7-8, 7-9                        → 3개
차이: |6 - 3| = 3
```

다른 전선들도 확인하면 최솟값이 **3**임을 알 수 있습니다.

---

## 7. BFS vs DFS

이 문제는 BFS와 DFS 둘 다 사용 가능합니다.

| | BFS (Solution1) | DFS (Solution2) |
|--|--|--|
| 구현 방식 | Queue 반복문 | 재귀 호출 |
| 장점 | 직관적, 스택 오버플로 없음 | 코드 간결 |
| 성능 | 동일 O(n²) | 동일 O(n²) |
