package platform.programmers.BruteForce.전력망을_둘로_나누기;

import java.util.*;

class Solution1 {
    public int solution(int n, int[][] wires) {
        int answer = n;
        List<List<Integer>> graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) graph.add(new ArrayList<>());
        for (int[] wire : wires) {
            graph.get(wire[0]).add(wire[1]);
            graph.get(wire[1]).add(wire[0]);
        }
        for (int[] wire : wires) {
            int count = bfs(n, graph, wire[0], wire[1]);
            answer = Math.min(answer, Math.abs(2 * count - n));
        }
        return answer;
    }

    private int bfs(int n, List<List<Integer>> graph, int cut1, int cut2) {
        boolean[] visited = new boolean[n + 1];
        Queue<Integer> queue = new LinkedList<>();
        queue.add(1); visited[1] = true;
        int count = 0;
        while (!queue.isEmpty()) {
            int curr = queue.poll(); count++;
            for (int next : graph.get(curr)) {
                if (!visited[next]
                    && !(curr == cut1 && next == cut2)
                    && !(curr == cut2 && next == cut1)) {
                    visited[next] = true; queue.add(next);
                }
            }
        }
        return count;
    }

    public int solution1(int n, int[][] wires) {
        int minDiff = Integer.MAX_VALUE;

        List<List<Integer>> graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) graph.add(new ArrayList<>());

        for (int[] wire : wires) {
            graph.get(wire[0]).add(wire[1]);
            graph.get(wire[1]).add(wire[0]);
        }

        for (int[] wire : wires) {
            int countA = bfs1(1, wire[0], wire[1], n, graph);
            int countB = n - countA;
            minDiff = Math.min(minDiff, Math.abs(countA - countB));
        }


        return minDiff;
    }

    int bfs1(int start, int cutV1, int cutV2, int n, List<List<Integer>> graph) {
        boolean[] visited = new boolean[n + 1];
        Queue<Integer> queue = new LinkedList<>();

        queue.add(start);
        visited[start] = true;
        int count = 0;

        while (!queue.isEmpty()) {
            int cur = queue.poll();
            count++;

            for (int next : graph.get(cur)) {
                if (visited[next]) continue;

                if ((cur == cutV1 && next == cutV2) ||
                        (cur == cutV2 && next == cutV1)) continue;

                visited[next] = true;
                queue.add(next);
            }
        }

        return count;
    }

}
