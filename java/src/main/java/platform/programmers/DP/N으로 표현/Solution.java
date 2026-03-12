// https://school.programmers.co.kr/learn/courses/30/lessons/42895

package platform.programmers.hash.N으로 표현;

import java.util.*;

class Solution {
    public int solution(int N, int number) {

        List<Set<Integer>> dp = new ArrayList<>();
        dp.add(new HashSet<>());

        for (int k = 1; k <= 8; k++) {
            Set<Integer> set = new HashSet<>();

            int concat = 0;
            for (int i = 0; i < k; i++) {
                concat = concat * 10 + N;
            }
            set.add(concat);

            for (int i = 1; i < k; i++) {
                for (int a : dp.get(i)) {
                    for ( int b : dp.get(k - i)) {
                        set.add(a + b);
                        set.add(a - b);
                        set.add(a * b);
                        if ( b != 0 ) set.add(a / b);
                    }
                }
            }

            if (set.contains(number)) return k;

            dp.add(set);
        }

        return -1;

    }
}