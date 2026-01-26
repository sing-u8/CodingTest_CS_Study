// https://school.programmers.co.kr/learn/courses/30/lessons/43164

import java.util.*;

class Solution {
    // 목적지들을 우선순위 큐에 담아 항상 알파벳 순으로 먼저 방문하도록 함
    Map<String, PriorityQueue<String>> graph = new HashMap<>();
    LinkedList<String> route = new LinkedList<>();

    public String[] solution(String[][] tickets) {
        // 1. 그래프 구성 (Min-Heap PriorityQueue 사용)
        for (String[] t : tickets) {
            graph.putIfAbsent(t[0], new PriorityQueue<>());
            graph.get(t[0]).add(t[1]);
        }

        // 2. DFS 시작
        dfs("ICN");

        // 3. 결과 반환 (List를 배열로 변환)
        return route.toArray(new String[0]);
    }

    public void dfs(String airport) {
        // 해당 공항에서 출발하는 티켓이 남아있는 동안 계속 깊이 탐색
        while (graph.containsKey(airport) && !graph.get(airport).isEmpty()) {
            // 알파벳 순서가 가장 빠른 도착지를 꺼냄 (Poll: 간선 삭제 효과)
            String nextDest = graph.get(airport).poll();
            dfs(nextDest);
        }

        // 더 이상 갈 곳이 없으면(막다른 곳 or 모든 티켓 소진) 경로의 맨 앞에 추가
        // 스택에서 빠져나올 때 경로가 역순으로 쌓이는 원리
        route.addFirst(airport);
    }
}