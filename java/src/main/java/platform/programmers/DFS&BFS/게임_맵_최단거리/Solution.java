// https://school.programmers.co.kr/learn/courses/30/lessons/1844?language=java

package platform.programmers.hash.게임_맵_최단거리;

import java.util.*;

class Solution {
    public int solution(int[][] maps) {

        return DFS_solution(maps);
    }

    class Node {
        int x, y, cost;

        public Node(int x, int y, int cost) {
            this.x = x;
            this.y = y;
            this.cost = cost;
        }
    }

    public int BFS_solution(int[][] maps) {
        int [][] dLoc = {{-1, 0}, {1, 0}, {0, -1}, {0, 1}};
        int n = maps.length;
        int m = maps[0].length;
        boolean [][] visited = new boolean[n][m];

        Queue<Node> queue = new LinkedList<>();

        queue.offer(new Node(0, 0, 1));
        visited[0][0] = true;

        while(!queue.isEmpty()) {

            Node curNode = queue.poll();
            int cx = curNode.x;
            int cy = curNode.y;
            int dist = curNode.cost;

            if (cx == n - 1 && cy == m - 1) return dist;

            for (int i = 0; i < dLoc.length; i++) {
                int nx = cx + dLoc[i][0];
                int ny = cy + dLoc[i][1];

                if (nx < 0 || nx >= n || ny < 0 || ny >= m) continue;

                if (maps[nx][ny] == 0 || visited[nx][ny]) continue;

                visited[nx][ny] = true;
                queue.offer(new Node(nx, ny, dist + 1));
            }

        }

        return -1;
    }


    // 효율성에서 0점
    int[] dx = {1, -1, 0, 0};
    int[] dy = {0, 0 , -1, 1};
    int answer = Integer.MAX_VALUE;
    boolean[][] visit;
    int N, M;

    public int DFS_solution(int[][] maps) {
        N = maps.length;
        M = maps[0].length;
        visit = new boolean[N][M];

        visit[0][0] = true;
        dfs(maps, 0, 0, 1);

        return answer == Integer.MAX_VALUE ? -1 : answer;
    }
    public void dfs(int[][] maps, int x, int y, int dist) {
        if (dist >= answer) return;
        if (x == N - 1 && y == M - 1) {
            answer = Math.min(answer, dist);
            return;
        }

        for (int i = 0; i < 4; i++) {
            int nx = x + dx[i];
            int ny = y + dy[i];

            if (nx >= 0 && nx < N && ny >= 0 && ny < M) {
                if (maps[nx][ny] == 1 && !visit[nx][ny]) {
                    visit[nx][ny] = true;
                    dfs(maps, nx, ny, dist + 1);
                    visit[nx][ny] = false;
                }
            }
        }
    }
}