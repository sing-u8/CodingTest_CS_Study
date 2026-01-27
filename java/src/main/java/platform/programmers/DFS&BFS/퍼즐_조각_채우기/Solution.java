// https://school.programmers.co.kr/learn/courses/30/lessons/84021
import java.util.*;

class Solution {

    static class Point implements Comparable<Point> {
        int x, y;
        public Point(int x, int y) {
            this.x = x;
            this.y = y;
        }

        @Override
        public int compareTo(Point o) {
            if (this.x == o.x) return this.y - o.y;
            return this.x - o.x;
        }
    }

    int[] dx = {-1, 1, 0, 0};
    int[] dy = {0, 0, -1, 1};
    int boardSize;

    public int solution(int[][] game_board, int[][] table) {
        boardSize = game_board.length;

        List<List<Point>> emptySpaces = extractShapes(game_board, 0);
        List<List<Point>> puzzlePieces = extractShapes(table, 1);

        int answer = 0;
        boolean[] visitedPieces = new boolean[puzzlePieces.size()];

        for (List<Point> space : emptySpaces) {
            for (int i=0; i < puzzlePieces.size(); i++) {

                if (visitedPieces[i]) continue;

                List<Point> piece = puzzlePieces.get(i);

                if (space.size() != piece.size()) continue;

                if (isMatch(space, piece)) {
                    visitedPieces[i] = true;
                    answer += space.size();
                    break;
                }
            }
        }

        return answer;
    }

    private List<List<Point>> extractShapes(int[][] board, int target) {
        List<List<Point>> shapes = new ArrayList<>();
        boolean[][] visited = new boolean[boardSize][boardSize];

        for (int x = 0; x < boardSize; x++) {
            for (int y = 0; y < boardSize; y++) {
                if (board[x][y] == target && !visited[x][y]) {
                    List<Point> shape = new ArrayList<>();
                    Queue<Point> q = new LinkedList<>();

                    q.add(new Point(x, y));
                    visited[x][y] = true;
                    shape.add(new Point(x,y));

                    while (!q.isEmpty()) {
                        Point curr = q.poll();
                        for (int i = 0; i < 4; i++) {
                            int nx = curr.x + dx[i];
                            int ny = curr.y + dy[i];

                            if (nx >= 0 && ny >= 0 && nx < boardSize && ny < boardSize) {
                                if (board[nx][ny] == target && !visited[nx][ny]) {
                                    visited[nx][ny] = true;
                                    Point next = new Point(nx, ny);
                                    q.add(next);
                                    shape.add(next);
                                }
                            }
                        }
                    }

                    shapes.add(normalize(shape));
                }
            }
        }
        return shapes;
    }

    private List<Point> normalize(List<Point> shape) {
        int minX = Integer.MAX_VALUE;
        int minY = Integer.MAX_VALUE;

        for (Point p : shape) {
            minX = Math.min(minX, p.x);
            minY = Math.min(minY, p.y);
        }

        List<Point> normalized = new ArrayList<>();
        for (Point p : shape) {
            normalized.add(new Point(p.x - minX, p.y - minY));
        }

        Collections.sort(normalized);
        return normalized;
    }

    private boolean isMatch(List<Point> space, List<Point> piece) {
        for (int i = 0; i < 4; i++) {
            boolean match = true;
            for (int j = 0; j < space.size(); j++) {
                if (space.get(j).x != piece.get(j).x || space.get(j).y != piece.get(j).y) {
                    match = false;
                    break;
                }
            }

            if (match) return true;
            piece = rotate(piece);
        }
        return false;
    }

    private List<Point> rotate(List<Point> shape) {
        List<Point> rotated = new ArrayList<>();
        for (Point p : shape) {
            rotated.add(new Point(p.y, -p.x));
        }
        return normalize(rotated);
    }
}