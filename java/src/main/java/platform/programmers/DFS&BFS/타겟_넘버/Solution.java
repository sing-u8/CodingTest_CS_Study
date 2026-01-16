package platform.programmers.hash.타겟_넘버;

import java.util.ArrayList;
import java.util.List;

class Solution {
    static int answer = 0;
    public int solution(int[] numbers, int target) {
        return solution4(numbers, target);
    }

    // ---------------------------

    public int solution1(int[] numbers, int target) {
        answer = 0;
        dfs1(numbers, target, 0, 0);
        return answer;
    }
    public void dfs1(int[] numbers, int target, int index, int sum) {
        if (index == numbers.length) {
            if (sum == target) answer ++;
            return;
        }

        dfs1(numbers, target, index + 1, sum + numbers[index]);
        dfs1(numbers, target, index + 1, sum - numbers[index]);
    }

    // ---------------------------

    public int solution2(int[] numbers, int target) {
        BsTree bst = new BsTree();

        // 1. 초기 루트 노드 생성 (합계에 영향이 없는 0)
        bst.insert(0);

        // 2. 숫자들을 하나씩 꺼내며 트리 확장 (모든 말단 노드에 +, - 자식 추가)
        for (int num : numbers) {
            bst.insert(num);
        }

        // 3. DFS 탐색으로 타겟 넘버 경우의 수 계산
        return bst.dfsPreOrder(target);
    }
    static class Node {
        int value;
        Node left;
        Node right;

        public Node(int value) {
            this.value = value;
            this.left = null;
            this.right = null;
        }
    }

    static class BsTree {

        Node root;
        int count;

        public BsTree() {
            this.root = null;
            this.count = 0;
        }

        public void insert(int value) {
            Node newNode = new Node(value);
            if (this.root == null) {
                this.root = newNode;
            } else {
                this.expandLeaves(this.root, value);
            }
        }
        private void expandLeaves(Node node, int value) {
            if (node.left != null) this.expandLeaves(node.left, value);
            if (node.right != null) this.expandLeaves(node.right, value);

            if (node.left == null) {
                node.left = new Node(-value);
                node.right = new Node(value);
            }
        }

        public int dfsPreOrder(int target) {
            this.count = 0;
            this.traverse(this.root, 0, target);
            return this.count;
        }
        private void traverse(Node node, int curSum, int target) {
            curSum += node.value;

            if (node.left != null) this.traverse(node.left, curSum, target);
            if (node.right != null) this.traverse(node.right, curSum, target);

            if (node.left == null && curSum == target) {
                this.count ++;
            }
        }

    }

    // --------------------------

    public int solution3(int[] numbers, int target) {
        // 현재 단계까지 계산된 모든 가능한 합계를 저장하는 리스트
        List<Integer> sums = new ArrayList<>();
        sums.add(0);

        for (int num : numbers) {
            List<Integer> nextSums = new ArrayList<>();
            for (int s : sums) {
                nextSums.add(s + num); // 더하기
                nextSums.add(s - num); // 빼기
            }
            sums = nextSums; // 다음 단계를 위해 리스트 교체
        }

        // 최종 리스트에서 target과 같은 값 개수 세기
        int count = 0;
        for (int s : sums) {
            if (s == target) count++;
        }
        return count;
    }

    // --------------------------
    public int solution4(int[] numbers, int target) {
        int n = numbers.length;
        int count = 0;

        // 1 << n 은 2^n 을 의미합니다. (예: n=3이면 8)
        for (int i = 0; i < (1 << n); i++) {
            int sum = 0;

            for (int j = 0; j < n; j++) {
                // 비트 연산: j번째 비트가 1인지 확인
                if ((i & (1 << j)) != 0) {
                    sum -= numbers[j]; // 1이면 뺌
                } else {
                    sum += numbers[j]; // 0이면 더함
                }
            }

            if (sum == target) count++;
        }
        return count;
    }

}