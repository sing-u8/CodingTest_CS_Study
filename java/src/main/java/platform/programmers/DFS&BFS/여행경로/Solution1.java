// https://school.programmers.co.kr/learn/courses/30/lessons/43164

import java.util.*;

class Solution {
    boolean[] visited;
    ArrayList<String> allRoute;

    public String[] solution(String[][] tickets) {
        // 1. 인접 리스트 생성 시 자동 정렬 효과를 위해 내용물만 정렬하거나 PriorityQueue 사용 고려
        // 하지만 인덱스 기반 방문 체크를 위해 여기서는 tickets 자체를 정렬합니다.
        Arrays.sort(tickets, (a, b) -> {
            if(a[0].equals(b[0])) return a[1].compareTo(b[1]);
            return a[0].compareTo(b[0]);
        });

        visited = new boolean[tickets.length];
        allRoute = new ArrayList<>();

        // 경로 탐색 시작
        dfs("ICN", "ICN", tickets, 0);

        return allRoute.get(0).split(" ");
    }

    public boolean dfs(String start, String route, String[][] tickets, int cnt){
        // 모든 티켓을 사용했을 때 (기저 조건)
        if(cnt == tickets.length){
            allRoute.add(route);
            return true; // 정답을 찾았으므로 true 반환하여 탐색 종료
        }

        for(int i = 0; i < tickets.length; i++){
            // 출발지가 일치하고, 아직 사용하지 않은 티켓인 경우
            if(tickets[i][0].equals(start) && !visited[i]){
                visited[i] = true;
                // 정렬되어 있으므로 가장 먼저 완성된 경로가 알파벳 순서상 앞섬
                if(dfs(tickets[i][1], route + " " + tickets[i][1], tickets, cnt + 1)){
                    return true;
                }
                visited[i] = false; // 백트래킹
            }
        }
        return false;
    }
}


/// 최적화 코드

import java.util.*;

class Solution {
    boolean[] visited;
    List<String> answer; // 최종 정답을 저장할 리스트

    public String[] solution(String[][] tickets) {
        // 1. 티켓 정렬 (알파벳 순서 앞서는 경로 우선 탐색을 위해)
        Arrays.sort(tickets, (a, b) -> {
            if (a[0].equals(b[0])) return a[1].compareTo(b[1]);
            return a[0].compareTo(b[0]);
        });

        visited = new boolean[tickets.length];

        // 탐색용 현재 경로 리스트 생성
        ArrayList<String> currentPath = new ArrayList<>();
        currentPath.add("ICN"); // 시작점 미리 추가

        dfs("ICN", tickets, currentPath);

        // List<String>을 String[] 배열로 변환하여 반환
        return answer.toArray(new String[0]);
    }

    public boolean dfs(String now, String[][] tickets, List<String> currentPath) {
        // 기저 조건: 경로에 담긴 도시 수가 (티켓 수 + 1)이면 모든 티켓을 사용한 것임
        if (currentPath.size() == tickets.length + 1) {
            // 주의: currentPath는 계속 변하므로, 현재 상태를 복사해서 저장해야 함!
            answer = new ArrayList<>(currentPath);
            return true;
        }

        for (int i = 0; i < tickets.length; i++) {
            // 현재 공항(now)에서 출발하고, 아직 사용 안 한 티켓 찾기
            if (!visited[i] && tickets[i][0].equals(now)) {

                // [상태 변경]
                visited[i] = true;
                currentPath.add(tickets[i][1]); // 리스트에 목적지 추가

                // [재귀 호출]
                if (dfs(tickets[i][1], tickets, currentPath)) {
                    return true; // 정답 찾으면 즉시 종료
                }

                // [백트래킹 - 상태 복구] ★ 가장 중요한 부분 ★
                // 방금 넣었던 목적지를 다시 뺍니다. (마지막 인덱스 삭제)
                currentPath.remove(currentPath.size() - 1);
                visited[i] = false;
            }
        }

        return false;
    }
}