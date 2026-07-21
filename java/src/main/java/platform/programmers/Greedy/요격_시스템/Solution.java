package platform.programmers.Greedy.요격_시스템;

import java.util.Arrays;
import java.util.Comparator;

/**
 * 프로그래머스 - 요격 시스템 (Lv.2)
 * https://school.programmers.co.kr/learn/courses/30/lessons/181188
 *
 * 핵심:
 * 1. 폭격 구간을 끝점 오름차순으로 정렬한다.
 * 2. 아직 요격되지 않은 구간을 만나면 그 구간의 끝점 바로 직전에 요격한다.
 * 3. 구간은 개구간 (s, e)이므로 start == selectedEnd인 경우에도 새 요격이 필요하다.
 */
class Solution {

    public int solution(int[][] targets) {
        Arrays.sort(
                targets,
                Comparator.comparingInt(target -> target[1])
        );

        int interceptorCount = 0;
        int selectedEnd = -1;

        for (int[] target : targets) {
            int start = target[0];
            int end = target[1];

            if (start >= selectedEnd) {
                interceptorCount++;
                selectedEnd = end;
            }
        }

        return interceptorCount;
    }
}
