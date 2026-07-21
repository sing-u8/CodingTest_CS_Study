// https://school.programmers.co.kr/learn/courses/30/lessons/42584

import java.util.ArrayDeque;
import java.util.Deque;

class Solution {
    public int[] solution(int[] prices) {
        int n = prices.length;
        int[] answer = new int[n];
        // 스택에는 '아직 가격이 떨어지지 않은' 시점의 인덱스를 저장
        Deque<Integer> stack = new ArrayDeque<>();

        for (int i = 0; i < n; i++) {
            // 현재 가격이 스택 top 시점의 가격보다 낮으면 → 가격이 떨어진 시점
            while (!stack.isEmpty() && prices[stack.peek()] > prices[i]) {
                int idx = stack.pop();
                answer[idx] = i - idx;  // 가격이 유지된 기간
            }
            stack.push(i);
        }

        // 스택에 남은 인덱스는 끝까지 가격이 떨어지지 않은 것
        while (!stack.isEmpty()) {
            int idx = stack.pop();
            answer[idx] = (n - 1) - idx;
        }

        return answer;
    }
}