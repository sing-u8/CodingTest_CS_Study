package platform.leetcode.heap.kth_largest_element_in_an_array;

import java.util.Arrays;
import java.util.Comparator;
import java.util.PriorityQueue;
import java.util.concurrent.ThreadLocalRandom;

/**
 * LeetCode 215. Kth Largest Element in an Array.
 *
 * 기본 진입점은 무작위 피벗과 3-way partition을 사용하는 Quickselect다.
 * 학습을 위해 최대 힙, 크기 k 최소 힙, 기본 Quickselect도 함께 제공한다.
 */
public class Solution {

    /**
     * 평균 O(n), 최악 O(n^2), 반복 구현 기준 추가 공간 O(1).
     * 입력 배열의 원소 순서를 변경한다.
     */
    public int findKthLargest(int[] nums, int k) {
        int targetIndex = nums.length - k;
        int left = 0;
        int right = nums.length - 1;

        while (left <= right) {
            int randomIndex = ThreadLocalRandom.current()
                    .nextInt(left, right + 1);
            int pivotValue = nums[randomIndex];

            // less: pivot보다 작은 영역이 끝난 다음 위치
            int less = left;

            // current: 다음에 검사할 미확인 원소의 위치
            int current = left;

            // greater: 아직 검사하지 않은 영역의 마지막 위치
            int greater = right;

            while (current <= greater) {
                if (nums[current] < pivotValue) {
                    swap(nums, less++, current++);
                } else if (nums[current] > pivotValue) {
                    // greater에서 current로 넘어온 값은 아직 미확인이므로
                    // current를 증가시키지 않는다.
                    swap(nums, current, greater--);
                } else {
                    current++;
                }
            }

            // [left, less)는 pivot보다 작고,
            // [less, greater]는 pivot과 같으며,
            // (greater, right]는 pivot보다 크다.
            if (targetIndex < less) {
                right = less - 1;
            } else if (targetIndex > greater) {
                left = greater + 1;
            } else {
                return nums[targetIndex];
            }
        }

        throw new IllegalStateException("Valid input must contain an answer.");
    }

    /**
     * 사용자가 처음 작성한 방식과 같은 최대 힙 풀이.
     * 시간 O(n log n), 공간 O(n).
     */
    public int findWithMaxHeap(int[] nums, int k) {
        PriorityQueue<Integer> maxHeap = new PriorityQueue<>(
                Comparator.reverseOrder()
        );

        for (int number : nums) {
            maxHeap.offer(number);
        }

        int answer = 0;
        for (int count = 0; count < k; count++) {
            answer = maxHeap.poll();
        }
        return answer;
    }

    /**
     * 가장 큰 k개만 보관하는 최소 힙 풀이.
     * 시간 O(n log k), 공간 O(k).
     */
    public int findWithMinHeap(int[] nums, int k) {
        PriorityQueue<Integer> minHeap = new PriorityQueue<>();

        for (int number : nums) {
            if (minHeap.size() < k) {
                minHeap.offer(number);
            } else if (number > minHeap.peek()) {
                minHeap.poll();
                minHeap.offer(number);
            }
        }

        return minHeap.peek();
    }

    /**
     * 마지막 원소를 피벗으로 사용하는 기본 2-way Quickselect.
     * 평균 O(n)이지만 정렬된 입력이나 중복이 많은 입력에서 편향될 수 있다.
     */
    public int findWithBasicQuickselect(int[] nums, int k) {
        int targetIndex = nums.length - k;
        return basicQuickselect(nums, 0, nums.length - 1, targetIndex);
    }

    private int basicQuickselect(
            int[] nums,
            int left,
            int right,
            int targetIndex
    ) {
        int pivotIndex = partition(nums, left, right);

        if (pivotIndex == targetIndex) {
            return nums[pivotIndex];
        }
        if (targetIndex < pivotIndex) {
            return basicQuickselect(
                    nums,
                    left,
                    pivotIndex - 1,
                    targetIndex
            );
        }
        return basicQuickselect(
                nums,
                pivotIndex + 1,
                right,
                targetIndex
        );
    }

    private int partition(int[] nums, int left, int right) {
        int pivotValue = nums[right];
        int storeIndex = left;

        for (int index = left; index < right; index++) {
            if (nums[index] <= pivotValue) {
                swap(nums, index, storeIndex++);
            }
        }

        swap(nums, storeIndex, right);
        return storeIndex;
    }

    private void swap(int[] nums, int first, int second) {
        int temporary = nums[first];
        nums[first] = nums[second];
        nums[second] = temporary;
    }

    public static void main(String[] args) {
        Solution solution = new Solution();

        int[][] testCases = {
                {3, 2, 1, 5, 6, 4},
                {3, 2, 3, 1, 2, 4, 5, 5, 6},
                {1},
                {-1, -1},
                {7, 7, 7, 7, 7}
        };
        int[] kValues = {2, 4, 1, 2, 3};
        int[] expected = {5, 4, 1, -1, 7};

        for (int index = 0; index < testCases.length; index++) {
            int[] values = testCases[index];
            int k = kValues[index];

            verify(
                    solution.findKthLargest(values.clone(), k),
                    expected[index],
                    "optimized Quickselect"
            );
            verify(
                    solution.findWithBasicQuickselect(values.clone(), k),
                    expected[index],
                    "basic Quickselect"
            );
            verify(
                    solution.findWithMaxHeap(values.clone(), k),
                    expected[index],
                    "max heap"
            );
            verify(
                    solution.findWithMinHeap(values.clone(), k),
                    expected[index],
                    "size-k min heap"
            );
        }

        System.out.println(
                "All Kth Largest examples passed: "
                        + Arrays.toString(expected)
        );
    }

    private static void verify(int actual, int expected, String method) {
        if (actual != expected) {
            throw new AssertionError(
                    method + ": expected=" + expected + ", actual=" + actual
            );
        }
    }
}
