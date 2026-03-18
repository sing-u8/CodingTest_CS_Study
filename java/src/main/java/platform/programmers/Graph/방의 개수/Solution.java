import java.util.*;

class Solution {
    public int solution(int[] arrows) {
        int[] dx = {0, 1, 1, 1, 0, -1, -1, -1};
        int[] dy = {1, 1, 0 ,-1, -1, -1, 0, 1};

        Set<String> visitedNodes = new HashSet<>();
        Set<String> visitedEdges = new HashSet<>();

        int rooms = 0;
        int x = 0, y = 0;
        visitedNodes.add(x + "," + y);

        for (int arrow : arrows) {
            for (int i = 0; i < 2; i++) {
                int nx = x + dx[arrow];
                int ny = y + dy[arrow];

                String nodeKey = nx + "," + ny;
                String edgeKey = x + "," + y + "-" + nx + "," + ny;
                String edgeKeyReverse = nx + "," + ny + "-" + x + "," + y;

                if (visitedNodes.contains(nodeKey) && !visitedEdges.contains(edgeKey)) {
                    rooms++;
                }

                visitedNodes.add(nodeKey);
                visitedEdges.add(edgeKey);
                visitedEdges.add(edgeKeyReverse);

                x = nx;
                y = ny;
            }
        }

        return rooms;
    }
}