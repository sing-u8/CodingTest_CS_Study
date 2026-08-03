package platform.leetcode.greedy.course_schedule_iii;

import java.util.Arrays;
import java.util.Comparator;
import java.util.PriorityQueue;

/**
 * LeetCode 630. Course Schedule III.
 *
 * 마감일 순으로 강의를 확인하고, 선택 시간이 마감일을 넘으면
 * 지금까지 선택한 강의 중 가장 긴 강의를 취소한다.
 */
public class Solution {

    public int scheduleCourse(int[][] courses) {
        Arrays.sort(
                courses,
                Comparator.comparingInt(course -> course[1])
        );

        PriorityQueue<Integer> selectedDurations = new PriorityQueue<>(
                Comparator.reverseOrder()
        );

        int totalDuration = 0;

        for (int[] course : courses) {
            int duration = course[0];
            int lastDay = course[1];

            totalDuration += duration;
            selectedDurations.offer(duration);

            if (totalDuration > lastDay) {
                totalDuration -= selectedDurations.poll();
            }
        }

        return selectedDurations.size();
    }

    public static void main(String[] args) {
        Solution solution = new Solution();

        verify(
                solution.scheduleCourse(copyOf(new int[][]{
                        {100, 200},
                        {200, 1300},
                        {1000, 1250},
                        {2000, 3200}
                })),
                3
        );
        verify(
                solution.scheduleCourse(copyOf(new int[][]{{1, 2}})),
                1
        );
        verify(
                solution.scheduleCourse(copyOf(new int[][]{
                        {3, 2},
                        {4, 3}
                })),
                0
        );
        verify(
                solution.scheduleCourse(copyOf(new int[][]{
                        {5, 6},
                        {4, 6},
                        {2, 6}
                })),
                2
        );
        verify(
                solution.scheduleCourse(copyOf(new int[][]{
                        {5, 5},
                        {4, 6},
                        {2, 6}
                })),
                2
        );
        verify(
                solution.scheduleCourse(copyOf(new int[][]{
                        {1, 100},
                        {2, 2},
                        {2, 4}
                })),
                3
        );

        System.out.println("All Course Schedule III examples passed.");
    }

    private static int[][] copyOf(int[][] courses) {
        return Arrays.stream(courses)
                .map(int[]::clone)
                .toArray(int[][]::new);
    }

    private static void verify(int actual, int expected) {
        if (actual != expected) {
            throw new AssertionError(
                    "expected=" + expected + ", actual=" + actual
            );
        }
    }
}
