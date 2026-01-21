// https://school.programmers.co.kr/learn/courses/30/lessons/43163?language=java

package platform.programmers.hash.단어_변환;

import java.util.*;

class Solution1 {
    public int solution(String begin, String target, String[] words) {
        // return BFS_solution(begin, target, words);
        return DFS_solution(begin, target, words);
    }

    public int BFS_solution(String begin, String target, String[] words) {
        // 1. 예외 처리: target이 words 안에 없으면 변환 불가능하므로 0 반환
        boolean isTargetContained = false;
        for (String word : words) {
            if (word.equals(target)) {
                isTargetContained = true;
                break;
            }
        }
        if (!isTargetContained) return 0;

        // 2. BFS 준비
        Queue<State> queue = new LinkedList<>();
        queue.offer(new State(begin, 0));
        // 방문 여부 체크 (words 배열의 인덱스 기준)
        boolean[] visited = new boolean[words.length];

        // 3. 탐색 시작
        while (!queue.isEmpty()) {
            State current = queue.poll();

            // 목표 단어 도달 시 단계 수 반환
            if (current.word.equals(target)) return current.step;

            // words 배열을 순회하며 다음으로 갈 수 있는 단어 찾기
            for (int i = 0; i < words.length; i++) {
                // 현재 단어와 한 글자만 차이나는지 확인 (변환 가능 여부) && 이미 방문한 단어가 아닌지 확인
                if (canConvert(current.word, words[i]) && !visited[i]) {
                    visited[i] = true;
                    queue.offer(new State(words[i], current.step + 1));
                }
            }

        }

        return 0;
    }

    // 큐에 넣을 상태 클래스 (단어, 현재까지의 단계 수)
    class State {
        String word;
        int step;

        public State(String word, int step) {
            this.word = word;
            this.step = step;
        }
    }

    private boolean canConvert(String w1, String w2) {
        int diffCnt = 0;
        for (int i = 0; i < w1.length(); i++) {
            if (w1.charAt(i) != w2.charAt(i)) diffCnt++;
        }
        return diffCnt == 1;
    }
}

// DFS
class Solution2 {
    boolean[] visited;
    int answer = Integer.MAX_VALUE; // 최솟값을 저장할 변수

    public int solution(String begin, String target, String[] words) {
        visited = new boolean[words.length];

        // DFS 시작
        dfs(begin, target, words, 0);

        // 정답이 갱신되지 않았으면(도착 못한 경우) 0 반환
        return answer == Integer.MAX_VALUE ? 0 : answer;
    }

    private void dfs(String current, String target, String[] words, int count) {
        // 1. 탈출 조건: 목표 단어에 도달했을 때
        if (current.equals(target)) {
            // 지금까지 찾은 최단 거리보다 짧으면 갱신
            answer = Math.min(answer, count);
            return;
        }

        // 2. 가지치기 (Pruning): 이미 찾은 최단 거리보다 더 깊이 들어가는 건 의미 없음
        if (count >= answer) {
            return;
        }

        // 3. 탐색
        for (int i = 0; i < words.length; i++) {
            // 방문하지 않았고, 변환 가능한 단어라면
            if (!visited[i] && canConvert(current, words[i])) {
                visited[i] = true;  // 방문 표시
                dfs(words[i], target, words, count + 1); // 재귀 호출 (깊게 들어감)
                visited[i] = false; // ★ 백트래킹 (다시 돌아나올 때 방문 해제)
            }
        }
    }

    private boolean canConvert(String w1, String w2) {
        int diff = 0;
        for (int i = 0; i < w1.length(); i++) {
            if (w1.charAt(i) != w2.charAt(i)) diff++;
        }
        return diff == 1;
    }
}

// 인접행렬 + BFS
import java.util.*;

class Solution3 {
    // 두 단어가 연결 가능한지 확인하는 함수
    private boolean canConvert(String w1, String w2) {
        int diff = 0;
        for (int i = 0; i < w1.length(); i++) {
            if (w1.charAt(i) != w2.charAt(i)) diff++;
        }
        return diff == 1;
    }

    public int solution(String begin, String target, String[] words) {
        // 1. Fail Fast: 타겟이 words에 없으면 바로 종료
        List<String> wordList = Arrays.asList(words);
        if (!wordList.contains(target)) return 0;

        // 2. 데이터 전처리: begin 단어를 포함하여 전체 단어 리스트 생성
        // (인덱스로 관리하기 위해 합칩니다. 0번 인덱스는 항상 begin이 됩니다.)
        List<String> allWords = new ArrayList<>();
        allWords.add(begin);
        allWords.addAll(wordList);

        int n = allWords.size();
        int targetIndex = allWords.indexOf(target); // 타겟 단어의 인덱스 저장

        // 3. 인접 리스트(Graph) 생성 - 여기가 핵심!
        // graph.get(i)는 i번 단어와 연결된 모든 단어의 인덱스를 가집니다.
        List<List<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }

        // 이중 포문으로 모든 쌍을 비교하여 연결 (양방향)
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                if (canConvert(allWords.get(i), allWords.get(j))) {
                    graph.get(i).add(j);
                    graph.get(j).add(i); // 양방향 연결
                }
            }
        }

        // 4. BFS 탐색 시작 (이제 글자 비교 없이 인덱스만 타고 다님)
        // 큐에는 {현재 단어 인덱스, 거리} 저장
        Queue<int[]> queue = new LinkedList<>();
        boolean[] visited = new boolean[n];

        queue.offer(new int[]{0, 0}); // 0번(begin)에서 시작, 거리 0
        visited[0] = true;

        while (!queue.isEmpty()) {
            int[] current = queue.poll();
            int currentIndex = current[0];
            int currentStep = current[1];

            // 타겟 인덱스에 도달하면 정답 반환
            if (currentIndex == targetIndex) {
                return currentStep;
            }

            // ★ 중요: for문을 전체 단어 수(N)만큼 돌 필요가 없음!
            // 미리 구해둔 '연결된 친구들(neighbors)'만 쏙쏙 뽑아옴
            for (int nextIndex : graph.get(currentIndex)) {
                if (!visited[nextIndex]) {
                    visited[nextIndex] = true;
                    queue.offer(new int[]{nextIndex, currentStep + 1});
                }
            }
        }

        return 0;
    }
}