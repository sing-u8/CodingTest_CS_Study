// https://school.programmers.co.kr/learn/courses/30/lessons/81303

import java.util.Stack;

class Solution {
    public String solution(int n, int k, String[] cmd) {
        // 이중 연결 리스트: prev[i] = 위쪽 행, next[i] = 아래쪽 행
        // -1 = 이전 행 없음(경계), n = 다음 행 없음(경계)
        int[] prev = new int[n];
        int[] next = new int[n];
        for (int i = 0; i < n; i++) {
            prev[i] = i - 1;
            next[i] = i + 1;
        }

        int cur = k;
        Stack<Integer> deleted = new Stack<>();

        for (String c : cmd) {
            if (c.equals("C")) {
                deleted.push(cur);
                int p = prev[cur], nx = next[cur];
                if (p != -1) next[p] = nx;     // 위쪽 이웃의 next를 아래쪽 이웃으로
                if (nx != n) prev[nx] = p;      // 아래쪽 이웃의 prev를 위쪽 이웃으로
                cur = (nx == n) ? p : nx;       // 마지막 행이었으면 위로, 아니면 아래로
            } else if (c.equals("Z")) {
                int restored = deleted.pop();
                int p = prev[restored], nx = next[restored];
                if (p != -1) next[p] = restored;  // 위쪽 이웃의 next 복원
                if (nx != n) prev[nx] = restored; // 아래쪽 이웃의 prev 복원
            } else {
                char dir = c.charAt(0);
                int x = Integer.parseInt(c.substring(2));
                if (dir == 'U') {
                    for (int i = 0; i < x; i++) cur = prev[cur];
                } else {
                    for (int i = 0; i < x; i++) cur = next[cur];
                }
            }
        }

        // 스택에 남은 행 = 최종 삭제 상태인 행
        boolean[] isDeleted = new boolean[n];
        while (!deleted.isEmpty()) isDeleted[deleted.pop()] = true;

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < n; i++) sb.append(isDeleted[i] ? 'X' : 'O');
        return sb.toString();
    }
}
