package platform.programmers.Greedy.섬 연결하기;

import java.util.*;

class Solution {
    public int solution(String name) {

        static int[] parent;
        static int[] rank;

        static int find(int x) {
          if (parent[x] != x) {
            parent[x] = find(parent[x]);
          }
          return parent[x];
        }

        static void union(int a, int b) {
            int rootA = find(a);
            int rootB = find(b);

            if (rootA == rootB) return;

            if (rank[rootA] < rank[rootB]) {
                parent[rootA] = rootB;
            } else if (rank[rootA] > rank[rootB]) {
                parent[rootB] = rootA;
            } else {
                parent[rootB] = rootA;
                rank[rootA]++;
            }
        }

        public int solution(int n, int[][] costs) {
            Arrays.sort(costs, (a, b) -> a[2] - b[2]);

            parent = new int[n];
            rank = new int[n];
            for (int i = 0; i < n; i++) {
                parent[i] = i;
                rank[i] = 0;
            }

            int totalCost = 0;
            int edgeCount = 0;

            for (int[] edge : costs) {
                int from = edge[0];
                int to   = edge[1];
                int cost = edge[2];

                if (find(from) != find(to)) {
                    union(from, to);
                    totalCost += cost;
                    edgeCount++;
                }

                if (edgeCount == n - 1) break;
            }

            return totalCost;
        }

    }
}
