class Solution {

    public int solution(String arr[]) {
        int n = (arr.length + 1) / 2;
        int[] nums = new int[n];
        int[] ops = new char[n - 1];
        for (int i = 0; i < arr.length; i++) {
            if (i % 2 == 0) nums[i / 2] = Integer.parseInt(arr[i]);
            else ops[i / 2] = arr[i].charAt(0);
        }

        long INF = (long) 1e15;
        long[][] maxDP = new long[n][n];
        long[][] minDP = new long[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                maxDP[i][j] = -INF;
                minDP[i][j] = INF;
            }
        }

        for (int i = 0; i < n; i++) {
            maxDP[i][i] = nums[i];
            minDP[i][i] = nums[i];
        }

        for (int len = 2; len <= n; len++) {
            for (int i = 0; i <= n - len; i++) {
                int j = i + len - 1;
                for (int k = i; k < j; k++) {
                    if (ops[k] == '+') {
                        maxDP[i][j] = Math.max(maxDP[i][j], maxDP[i][k] + max[k+1][j]);
                        minDP[i][j] = Math.min(minDP[i][j], minDP[i][k] + minDP[k+1][j]);
                    } else {
                        maxDP[i][j] = Math.max(maxDP[i][j], maxDP[i][k] - min[k+1][j]);
                        minDP[i][j] = Math.min(minDP[i][j], minDP[i][k] - maxDP[k+1][j]);
                    }
                }
            }
        }

        return (int) maxDP[0][n - 1];
    }

    public int solution1(String arr[]) {
        int n = (arr.length + 1) / 2;
        int[] nums = new int[n];
        char[] ops = new char[n - 1];

        for (int i = 0; i < arr.length; i++) {
            if (i % 2 == 0) nums[i / 2] = Integer.parseInt(arr[i]);
            else ops[i / 2] = arr[i].charAt(0);
        }

        long[][] maxDP = new long[n][n];
        long[][] minDP = new long[n][n];
        long INF = (long) 1e15;

        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                maxDP[i][j] = -INF;
                minDP[i][j] = INF;
            }
        }

        for (int len = 1; len <= n; len++) {
            for (int i = 0; i <= n - len; i++) {
                int j = i + len - 1;

                if (len == 1) {
                    maxDP[i][j] = nums[i];
                    minDP[i][j] = nums[i];
                    continue;
                }

                for (int k = i; k < j; k++) {
                    if (ops[k] == '+') {
                        maxDP[i][j] = Math.max(maxDP[i][j], maxDP[i][k] + maxDP[k + 1][j]);
                        minDP[i][j] = Math.min(minDP[i][j], minDP[i][k] + minDP[k + 1][j]);
                    } else {
                        maxDP[i][j] = Math.max(maxDP[i][j], maxDP[i][k] - minDP[k + 1][j]);
                        minDP[i][j] = Math.min(minDP[i][j], minDP[i][k] - maxDP[k + 1][j]);
                    }
                }
            }
        }

        return (int) maxDP[0][n - 1];
    }
}