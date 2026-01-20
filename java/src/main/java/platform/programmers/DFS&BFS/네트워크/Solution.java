// https://school.programmers.co.kr/learn/courses/30/lessons/43162?language=java

package platform.programmers.hash.네트워크;

import java.util.*;

class Solution {
    public int solution(int n, int[][] computers) {
        // return dfsSolution(n, computers);
        // return bfsSolution(n, computers);
        return OOP_style_solution(n, computers);
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

    //------------------ OOP Style --------------------------
    static class Computer {
        private int idx;
        private boolean isVisited;
        private List<Computer> neighbors; // 나와 연결된 이웃 컴퓨터 목록

        public Computer(int idx) {
            this.idx = idx;
            this.isVisited = false;
            this.neighbors = new ArrayList<>();
        }

        // 이웃 컴퓨터 연결하기 (관계 형성)
        public void addNeighbor(Computer other) {
            this.neighbors.add(other);
        }

        // 나의 방문 상태 확인 (Getter)
        public boolean isVisited() {
            return this.isVisited;
        }

        // 핵심 로직: 네트워크 전파 (DFS가 객체 내부로 이동)
        public void spreadNetwork() {
            if (this.isVisited) return; // 이미 방문했다면 종료

            this.isVisited = true; // 방문 처리 (내 상태 변경)

            // 내 이웃들에게 "너도 네트워크 연결해!"라고 메시지 전달
            for (Computer neighbor : neighbors) {
                neighbor.spreadNetwork(); // 재귀적 호출 (객체끼리의 협력)
            }
        }
    }
    public int OOP_style_solution(int n, int[][] computers) {
        // A. 객체 생성 단계
        List<Computer> computerList = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            computerList.add(new Computer(i));
        }

        // B. 객체 연결 단계 (관계 맺기)
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (i != j && computers[i][j] == 1) {
                    // i번 컴퓨터에게 j번 컴퓨터를 이웃으로 추가하라고 지시
                    computerList.get(i).addNeighbor(computerList.get(j));
                }
            }
        }

        // C. 네트워크 개수 세기 (비즈니스 로직)
        int count = 0;
        for (Computer comp : computerList) {
            // "아직 방문 안 했니?" 라고 객체에게 물어봄
            if (!comp.isVisited()) {
                count++;
                // "네트워크 퍼뜨려!" 라고 객체에게 명령
                comp.spreadNetwork();
            }
        }

        return count;
    }

}