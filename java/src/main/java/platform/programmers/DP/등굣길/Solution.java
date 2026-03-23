class Solution {
    public int solution(int m, int n, int[][] puddles) {
        final int MOD = 1_000_000_007;

        int[][] dp = new int[n + 1][m + 1];

        for (int[] p : puddles) {
            dp[p[1]][p[0]] = -1;
        }

        dp[1][1] = 1;

        for (int r = 1; r <= n; r++) {
            for (int c = 1; c <= m; c++) {
                if (r == 1 && c == 1) continue;

                if (dp[r][c] == -1) {
                    dp[r][c] = 0;
                    continue;
                }

                long fromUp = (r > 1) ? dp[r - 1][c] : 0;
                long Fromleft = (c > 1) ? dp[r][c - 1] : 0;
                dp[r][c] = (int)((fromUp + Fromleft) % MOD);
            }
        }

        return dp[n][m];
    }
}