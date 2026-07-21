// https://school.programmers.co.kr/learn/courses/30/lessons/12973

import java.util.ArrayDeque;
import java.util.Deque;

class Solution {
    public int solution(String s) {
        // ArrayDeque를 스택 용도로 사용 (Stack 클래스보다 빠름)
        Deque<Character> stack = new ArrayDeque<>();
        for (int i = 0; i < s.length(); i++) {
            char ch = s.charAt(i);
            // top이 현재 문자와 같으면 pop (짝 제거)
            if (!stack.isEmpty() && stack.peek() == ch) {
                stack.pop();
            } else {
                // 다르면 push
                stack.push(ch);
            }
        }
        // 최종적으로 비어있으면 성공
        return stack.isEmpty() ? 1 : 0;
    }
}
