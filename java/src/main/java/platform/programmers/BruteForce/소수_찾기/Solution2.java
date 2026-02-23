import java.util.HashSet;

class Solution {
    // 생성된 모든 숫자를 저장할 Set (중복 제거용)
    HashSet<Integer> generatedNumbers = new HashSet<>();
    // 방문 여부를 체크할 배열
    boolean[] isUsed;
    // 입력받은 숫자 문자열을 전역으로 사용
    String digits;

    public int solution(String numbers) {
        this.digits = numbers;
        // 종이 조각 개수만큼 방문 배열 초기화
        this.isUsed = new boolean[numbers.length()];

        // 1. DFS 시작 (빈 문자열부터 시작)
        dfs("");

        // 2. 생성된 숫자들 중 소수 개수 세기
        int count = 0;
        for (int num : generatedNumbers) {
            if (isPrime(num)) {
                count++;
            }
        }
        return count;
    }

    // DFS 함수: 현재까지 만들어진 문자열 currentStr을 받음
    public void dfs(String currentStr) {
        // 기저 조건(Base Case)은 따로 없으며, 모든 경우를 다 탐색합니다.

        // 현재까지 만들어진 문자열이 비어있지 않다면 Set에 추가
        if (!currentStr.equals("")) {
            // "011" -> 11 로 변환되며 Set이 알아서 중복 처리
            generatedNumbers.add(Integer.valueOf(currentStr));
        }

        // 가진 종이 조각들을 모두 순회하며 다음 글자 붙이기 시도
        for (int i = 0; i < digits.length(); i++) {
            // i번째 종이 조각을 아직 사용하지 않았다면
            if (!isUsed[i]) {
                // 1. 체크(방문 표시): 이 조각 사용함
                isUsed[i] = true;

                // 2. 들어가기(재귀 호출): 현재 문자열에 이 조각을 붙여서 다음 단계로 진행
                dfs(currentStr + digits.charAt(i));

                // 3. 나오기(백트래킹): 다른 조합을 만들기 위해 사용 표시 해제
                isUsed[i] = false;
            }
        }
    }

    // 소수 판별 함수 (효율성 O(sqrt(N)))
    public boolean isPrime(int num) {
        if (num < 2) return false;
        for (int i = 2; i * i <= num; i++) {
            if (num % i == 0) return false;
        }
        return true;
    }
}