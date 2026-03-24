import java.util.*;

class Solution {
    public int solution(int n, int[][] edge) {
        // 인접 리스트로 그래프 구성
        List<List<Integer>> graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) {
            graph.add(new ArrayList<>());
        }
        for (int[] e : edge) {
            graph.get(e[0]).add(e[1]);
            graph.get(e[1]).add(e[0]);
        }

        // BFS로 1번 노드에서 각 노드까지의 최단 거리 계산
        int[] dist = new int[n + 1];
        Arrays.fill(dist, -1);       // -1은 미방문 상태
        dist[1] = 0;

        Queue<Integer> queue = new LinkedList<>();
        queue.add(1);

        int maxDist = 0;

        while (!queue.isEmpty()) {
            int cur = queue.poll();
            for (int next : graph.get(cur)) {
                if (dist[next] == -1) {       // 아직 방문하지 않은 노드만
                    dist[next] = dist[cur] + 1;
                    maxDist = Math.max(maxDist, dist[next]);
                    queue.add(next);
                }
            }
        }

        // 최대 거리와 같은 노드 수 카운트
        int count = 0;
        for (int i = 1; i <= n; i++) {
            if (dist[i] == maxDist) count++;
        }
        return count;
    }
}