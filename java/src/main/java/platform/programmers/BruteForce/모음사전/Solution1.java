package platform.programmers.BruteForce.모음사전;

import java.util.*;

class Solution1 {
    private List<String> dict = new ArrayList<>();

    public int solution(String word) {
        dfs("");
        return dict.indexOf(word) + 1;
    }

    private void dfs(String current) {
        if (!current.isEmpty()) {
            dict.add(current);
        }
        if (current.length() == 5) return;
        for (char v : new char[]{'A', 'E', 'I', 'O', 'U'}) {
            dfs(current + v);
        }
    }
}
