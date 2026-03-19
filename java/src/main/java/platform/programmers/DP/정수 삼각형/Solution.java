class Solution {
    public int solution(int[][] triangle) {
        int n = triangle.length;
        int[][] dp = new int[n][];
        for (int i = 0; i < n; i++) {
            dp[i] = triangle[i].clone();
        }

        for (int i = 1; i < n; i++) {
            for (int j = 0; j <= i; j++) {
                if (j == 0) {
                    dp[i][j] += dp[i-1][j];
                } else if (j == i) {
                    dp[i][j] += dp[i-1][j-1];
                } else {
                    dp[i][j] += Math.max(dp[i-1][j], dp[i-1][j-1]);
                }
            }
        }

        int answer = 0;
        for (int val : dp[n - 1]) {
            answer = Math.max(answer, val);
        }
        return answer;
    }
}