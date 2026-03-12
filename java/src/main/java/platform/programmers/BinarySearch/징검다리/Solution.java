import java.util.Arrays;

class Solution {
    public int solution(int distance, int[] rocks, int n) {
        Arrays.sort(rocks);

        long left = 1;
        long right = distance;
        long answer = 0;

        while (left <= right) {
            long mid = (left + right) / 2;

            int removeCount = 0;
            int prev = 0;

            for (int rock : rocks) {
                if (rock - prev < mid) {
                    removeCount++;
                } else {
                    prev = rock;
                }
            }

            if (distance - prev < mid) {
                removeCount++;
            }

            if (removeCount <= n) {
                answer = mid;
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }

        return (int) answer;
    }
}