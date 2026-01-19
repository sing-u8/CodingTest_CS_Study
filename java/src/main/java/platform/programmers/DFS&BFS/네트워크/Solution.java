// https://school.programmers.co.kr/learn/courses/30/lessons/43162?language=java

package platform.programmers.hash.네트워크;

import java.util.*;

class Solution {
    public int solution(int n, int[][] computers) {
        // return dfsSolution(n, computers);
        return bfsSolution(n, computers);
    }

    //------------------ DFS --------------------------

    public int dfsSolution(int n, int[][] coms) {
        int networkCnt = 0;
        boolean[] visit = new boolean[n];

        for (int i = 0; i < n; i++) {
            if(!visit[i]) {
                dfs(n, coms, visit, i);
                networkCnt++;
            }
        }

        return networkCnt;
    }
    public void dfs(int n, int[][] coms, boolean[] visit, int idx) {
        visit[idx] = true;
        for (int j = 0; j < n; j++) {
            if (idx != j && !visit[j] && coms[idx][j] == 1) {
                dfs(n, coms, visit, j);
            }
        }
    }

    //------------------ BFS --------------------------

    public int bfsSolution(int n, int[][] coms) {
        int networkCnt = 0;
        boolean[] visit = new boolean[n];

        for (int i = 0; i < n; i++) {
            if(!visit[i]) {
                bfs(n, coms, visit, i);
                networkCnt++;
            }
        }

        return networkCnt;
    }
    public void bfs(int n, int[][] coms, boolean[] visit, int start) {
        Queue<Integer> q = new LinkedList<Integer>();

        q.offer(start);
        visit[start] = true;

        while (!q.isEmpty()) {
            int current = q.poll();
            for (int i = 0; i < n; i ++) {
                if (!visit[i] && coms[current][i] == 1) {
                    q.offer(i);
                    visit[i] = true;
                }
            }
        }

    }



}