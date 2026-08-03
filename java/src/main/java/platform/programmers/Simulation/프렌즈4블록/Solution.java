import java.util.Arrays;

public class Solution {

    private static final char EMPTY = '.';

    public int solution(int m, int n, String[] board) {
        char[][] map = new char[m][n];

        for (int row = 0; row < m; row++) {
            map[row] = board[row].toCharArray();
        }

        int totalRemovedCount = 0;

        while (true) {
            boolean[][] marked = new boolean[m][n];
            boolean foundRemovableBlock = markRemovableBlocks(
                    map,
                    marked,
                    m,
                    n
            );

            if (!foundRemovableBlock) {
                break;
            }

            totalRemovedCount += removeMarkedBlocks(
                    map,
                    marked,
                    m,
                    n
            );

            applyGravity(map, m, n);
        }

        return totalRemovedCount;
    }

    private boolean markRemovableBlocks(
            char[][] map,
            boolean[][] marked,
            int rowCount,
            int colCount
    ) {
        boolean found = false;

        for (int row = 0; row < rowCount - 1; row++) {
            for (int col = 0; col < colCount - 1; col++) {
                char block = map[row][col];

                if (block == EMPTY) {
                    continue;
                }

                if (map[row][col + 1] == block
                        && map[row + 1][col] == block
                        && map[row + 1][col + 1] == block) {
                    marked[row][col] = true;
                    marked[row][col + 1] = true;
                    marked[row + 1][col] = true;
                    marked[row + 1][col + 1] = true;
                    found = true;
                }
            }
        }

        return found;
    }

    private int removeMarkedBlocks(
            char[][] map,
            boolean[][] marked,
            int rowCount,
            int colCount
    ) {
        int removedCount = 0;

        for (int row = 0; row < rowCount; row++) {
            for (int col = 0; col < colCount; col++) {
                if (!marked[row][col]) {
                    continue;
                }

                map[row][col] = EMPTY;
                removedCount++;
            }
        }

        return removedCount;
    }

    private void applyGravity(char[][] map, int rowCount, int colCount) {
        for (int col = 0; col < colCount; col++) {
            int writeRow = rowCount - 1;

            for (int readRow = rowCount - 1; readRow >= 0; readRow--) {
                if (map[readRow][col] == EMPTY) {
                    continue;
                }

                map[writeRow][col] = map[readRow][col];
                writeRow--;
            }

            while (writeRow >= 0) {
                map[writeRow][col] = EMPTY;
                writeRow--;
            }
        }
    }

    public static void main(String[] args) {
        Solution solution = new Solution();

        verify(
                solution.solution(
                        4,
                        5,
                        new String[]{"CCBDE", "AAADE", "AAABF", "CCBBF"}
                ),
                14
        );
        verify(
                solution.solution(
                        6,
                        6,
                        new String[]{
                                "TTTANT",
                                "RRFACC",
                                "RRRFCC",
                                "TRRRAA",
                                "TTMMMF",
                                "TMMTTJ"
                        }
                ),
                15
        );
        verify(
                solution.solution(2, 3, new String[]{"AAA", "AAA"}),
                6
        );
        verify(
                solution.solution(2, 2, new String[]{"AB", "CD"}),
                0
        );

        System.out.println(
                "All Friends 4 Block examples passed: "
                        + Arrays.toString(new int[]{14, 15, 6, 0})
        );
    }

    private static void verify(int actual, int expected) {
        if (actual != expected) {
            throw new AssertionError(
                    "expected=" + expected + ", actual=" + actual
            );
        }
    }
}
