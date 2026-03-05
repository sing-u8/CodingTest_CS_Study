package platform.programmers.Greedy.조이스틱;

/**
 * 프로그래머스 - 조이스틱 (Lv.2)
 * https://school.programmers.co.kr/learn/courses/30/lessons/42860
 *
 * 문제 요약:
 *   조이스틱으로 A~Z 알파벳 이름을 완성하는 최소 조작 횟수를 구한다.
 *   ▲/▼: 해당 위치 알파벳 변경 (순환)
 *   ◀/▶: 커서 이동 (좌우 순환)
 *
 * 핵심 아이디어 (Greedy):
 *   답 = (상하 이동 합) + (좌우 이동 최솟값)
 *
 *   [상하 이동]
 *     각 문자를 A에서 목표 알파벳으로 바꾸는 최소 횟수
 *     - 위로: ch - 'A'
 *     - 아래로: 26 - (ch - 'A')  (Z→Y→...→A 방향)
 *     - 둘 중 최솟값 선택
 *
 *   [좌우 이동]
 *     기본값: n-1 (끝까지 오른쪽으로만 이동)
 *     연속된 'A' 구간이 있으면, 그 구간을 건너뛰는 것이 유리할 수 있음.
 *
 *     연속 A 구간(i ~ next-1)을 발견하면 두 가지 전략 비교:
 *       방법 1: 오른쪽으로 i까지 간 뒤, 왼쪽으로 돌아서 뒤쪽(n-next)을 처리
 *               → 2*i + (n - next)
 *       방법 2: 뒤쪽(n-next)을 먼저 왼쪽 방향으로 처리한 뒤, 오른쪽으로 i까지
 *               → i + 2*(n - next)
 *     두 방법 중 더 작은 값으로 move를 갱신
 */
class Solution {
    public int solution(String name) {
        int n = name.length();

        // ── 상하 이동 합산 ──
        int upDown = 0;
        for (char ch : name.toCharArray()) {
            int upMove = c - 'A';
            int downMove = 'Z' - c + 1; // 또는 downMove = 26 - upMove;
            upDown += Math.min(upMove, downMove);
        }

        // ── 좌우 이동 최솟값 ──
        int move = n - 1; // 기본값: 끝까지 오른쪽으로만 이동

        for (int i = 0; i < n; i++) {
            // i 이후 연속된 'A' 구간의 끝(next) 탐색
            int next = i + 1;
            while (next < n && name.charAt(next) == 'A') next++;

            // 방법1: 오른쪽 i까지 → 왼쪽 0으로 → 뒤쪽에서 왼쪽 방향으로 처리
            move = Math.min(move, 2 * i + (n - next));
            // 방법2: 뒤쪽 먼저 왼쪽 방향 처리 → 오른쪽 방향으로 i까지
            move = Math.min(move, i + 2 * (n - next));
        }

        return upDown + move;
    }
}
