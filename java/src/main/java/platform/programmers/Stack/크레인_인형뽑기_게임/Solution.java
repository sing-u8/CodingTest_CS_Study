// https://school.programmers.co.kr/learn/courses/30/lessons/64061

import java.util.ArrayDeque;
import java.util.Deque;
import java.util.Stack;

class Solution {
    public int solution(int[][] board, int[] moves) {
        int n = board.length;
        int count = 0;
        // 바구니: 뽑아서 쌓이는 인형들
        Deque<Integer> basket = new ArrayDeque<>();

        for (int col : moves) {
            int c = col - 1; // 1-indexed → 0-indexed 변환
            // 해당 열의 가장 위에 있는 인형 탐색
            for (int r = 0; r < n; r++) {
                if (board[r][c] != 0) {
                    int doll = board[r][c];
                    board[r][c] = 0; // 인형 뽑기
                    // 바구니 top과 같은 인형이면 짝 제거
                    if (!basket.isEmpty() && basket.peek() == doll) {
                        basket.pop();
                        count += 2;
                    } else {
                        basket.push(doll);
                    }
                    break; // 하나만 뽑고 다음 move로
                }
            }
        }

        return count;
    }
}

// 대안 풀이: 열별 스택 사전 구축 방식
// move마다 board를 스캔하는 대신, 미리 각 열을 Stack으로 변환해두고 O(1) pop으로 처리
class SolutionV2 {
    public int solution(int[][] board, int[] moves) {
        // lanes[j]: j번 열의 인형을 아래에서 위 순으로 쌓은 스택
        // board[0].length = 열의 수 → lanes 크기로 사용
        @SuppressWarnings("unchecked")
        Stack<Integer>[] lanes = new Stack[board[0].length];
        for (int i = 0; i < lanes.length; i++) {
            lanes[i] = new Stack<>();
        }

        // 각 열을 아래(board.length-1)에서 위(0) 방향으로 순회하며 스택에 push
        // 0(빈칸)을 만나면 break — 이 문제는 빈칸이 항상 위쪽에 있으므로 안전
        for (int j = 0; j < board[0].length; j++) {
            for (int i = board.length - 1; i >= 0; i--) {
                if (board[i][j] > 0) {
                    lanes[j].push(board[i][j]);
                } else {
                    break;
                }
            }
        }

        Stack<Integer> bucket = new Stack<>();
        int answer = 0;

        for (int move : moves) {
            if (!lanes[move - 1].isEmpty()) {
                int doll = lanes[move - 1].pop();
                if (!bucket.isEmpty() && bucket.peek() == doll) {
                    bucket.pop();
                    answer += 2;
                } else {
                    bucket.push(doll);
                }
            }
        }

        return answer;
    }
}
