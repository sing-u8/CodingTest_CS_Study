import java.util.*;

class Solution {
    // 맵의 최대 크기: 좌표값 50 * 2배 = 100, 여유분 포함 102
    static int[][] map;
    static int answer;

    // 상하좌우 이동 방향
    static int[] dx = {-1, 1, 0, 0};
    static int[] dy = {0, 0, -1, 1};

    public int solution(int[][] rectangle, int characterX, int characterY, int itemX, int itemY) {
        answer = 0;

        // 1. 맵 초기화 (모든 좌표를 2배로 늘림)
        map = new int[102][102];

        // 2. 테두리와 내부 채우기
        for (int[] rect : rectangle) {
            int x1 = rect[0] * 2;
            int y1 = rect[1] * 2;
            int x2 = rect[2] * 2;
            int y2 = rect[3] * 2;

            for (int x = x1; x <= x2; x++) {
                for (int y = y1; y <= y2; y++) {
                    // 이미 내부(2)로 채워진 곳은 건너뜀 (내부가 테두리보다 우선순위 높음)
                    if (map[x][y] == 2) continue;

                    // 현재 검사 중인 부분이 2배 늘린 직사각형의 테두리인지 확인
                    if (x == x1 || x == x2 || y == y1 || y == y2) {
                        // 테두리면 1로 표시
                        map[x][y] = 1;
                    } else {
                        // 테두리가 아니면 내부이므로 2로 표시
                        map[x][y] = 2;
                    }
                }
            }
        }

        // 3. BFS 탐색 시작 (시작점과 도착점도 2배)
        bfs(characterX * 2, characterY * 2, itemX * 2, itemY * 2);

        return answer;
    }

    private void bfs(int startX, int startY, int itemX, int itemY) {
        boolean[][] visited = new boolean[102][102];
        Queue<int[]> queue = new LinkedList<>();

        // x좌표, y좌표, 현재 이동 거리
        queue.add(new int[]{startX, startY, 0});
        visited[startX][startY] = true;

        while (!queue.isEmpty()) {
            int[] curr = queue.poll();
            int cx = curr[0];
            int cy = curr[1];
            int dist = curr[2];

            // 목표 지점 도달 시 종료
            if (cx == itemX && cy == itemY) {
                // 2배로 늘렸으니 결과는 2로 나눠줌
                answer = dist / 2;
                return;
            }

            for (int i = 0; i < 4; i++) {
                int nx = cx + dx[i];
                int ny = cy + dy[i];

                // 맵 범위 체크
                if (nx < 0 || ny < 0 || nx >= 102 || ny >= 102) continue;

                // 방문하지 않았고, 테두리(1)인 경우에만 이동
                if (!visited[nx][ny] && map[nx][ny] == 1) {
                    visited[nx][ny] = true;
                    queue.add(new int[]{nx, ny, dist + 1});
                }
            }
        }
    }
}