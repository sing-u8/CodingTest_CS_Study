package platform.programmers.BruteForce.전력망을_둘로_나누기;

import java.util.*;

class Solution2 {
    private List<List<Integer>> graph;
    private boolean[] visited;

    public int solution(int n, int[][] wires) {
        int answer = n;
        graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) graph.add(new ArrayList<>());
        for (int[] wire : wires) {
            graph.get(wire[0]).add(wire[1]);
            graph.get(wire[1]).add(wire[0]);
        }
        for (int[] wire : wires) {
            visited = new boolean[n + 1];
            int count = dfs(1, wire[0], wire[1]);
            answer = Math.min(answer, Math.abs(2 * count - n));
        }
        return answer;
    }

    private int dfs(int curr, int cut1, int cut2) {
        visited[curr] = true;
        int count = 1;
        for (int next : graph.get(curr)) {
            if (!visited[next]
                && !(curr == cut1 && next == cut2)
                && !(curr == cut2 && next == cut1)) {
                count += dfs(next, cut1, cut2);
            }
        }
        return count;
    }
}
