import java.util.*;

class Solution {
    public int solution(int n, int[][] results) {
        List<List<Integer>> winGraph = new ArrayList<>();
        List<List<Integer>> loseGraph = new ArrayList<>();
        for (int i = 0; i <= n; i++) {
            winGraph.add(new ArrayList<>());
            loseGraph.add(new ArrayList<>());
        }

        for (int[] r : results) {
            winGraph.get(r[0]).add(r[1]);
            loseGraph.get(r[1]).add(r[0]);
        }

        int answer = 0;
        for (int i = 1; i <= n; i++) {
            int known = bfs(i, winGraph, n) + bfs(i, loseGraph, n);
            if (known == n - 1) answer++;
        }
        return answer;
    }

    private int bfs(int start, List<List<Integer>> graph, int n) {
        boolean[] visited = new boolean[n + 1];
        visited[start] = true;

        Queue<Integer> queue = new LinkedList<>();
        queue.add(start);

        int count = 0;
        while (!queue.isEmpty()) {
            int cur = queue.poll();
            for (int next : graph.get(cur)) {
                if (!visited[next]) {
                    visited[next] = true;
                    count++;
                    queue.add(next);
                }
            }
        }
        return count;
    }

    public int solution2(int n, int[][] results) {
        // win[i][j] = true : i가 j를 (직접 or 간접) 이긴다
        boolean[][] win = new boolean[n + 1][n + 1];
        for (int[] r : results) {
            win[r[0]][r[1]] = true;
        }

        // 플로이드-워셜: 전이적 승리 관계 전파
        for (int k = 1; k <= n; k++) {         // k = 경유 노드
            for (int i = 1; i <= n; i++) {     // i = 출발 노드
                for (int j = 1; j <= n; j++) { // j = 도착 노드
                    if (win[i][k] && win[k][j]) {
                        win[i][j] = true;
                    }
                }
            }
        }

        int answer = 0;
        for (int i = 1; i <= n; i++) {
            int known = 0;
            for (int j = 1; j <= n; j++) {
                // i가 j를 이기든, j가 i를 이기든 관계가 밝혀진 것
                if (win[i][j] || win[j][i]) known++;
            }
            if (known == n - 1) answer++;
        }
        return answer;
    }
}