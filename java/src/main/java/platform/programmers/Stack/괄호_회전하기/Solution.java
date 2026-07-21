// https://school.programmers.co.kr/learn/courses/30/lessons/76502

import java.util.Map;
import java.util.Stack;

class Solution {
    private static final Map<Character, Character> MATCH = Map.of(
        ')', '(',
        ']', '[',
        '}', '{'
    );

    private boolean isValid(String ss, int start, int len) {
        Stack<Character> stack = new Stack<>();
        for (int i = 0; i < len; i++) {
            char ch = ss.charAt(start + i);
            if (ch == '(' || ch == '[' || ch == '{') {
                stack.push(ch);
            } else {
                if (stack.isEmpty() || !stack.peek().equals(MATCH.get(ch))) {
                    return false;
                }
                stack.pop();
            }
        }
        return stack.isEmpty();
    }

    public int solution(String s) {
        int n = s.length();
        if (n % 2 != 0) return 0;

        String ss = s + s;
        int count = 0;

        for (int x = 0; x < n; x++) {
            if (isValid(ss, x, n)) count++;
        }

        return count;
    }
}