package platform.programmers.hash.베스트앨범;

import java.util.*;
import java.util.stream.*;

class Solution {
    public int[] solution(String[] genres, int[] plays) {
        return solution2(genres, plays);
    }

    public int[] solution1(String[] genres, int[] plays) {
        HashMap<String, Integer> genresTotalMap = new HashMap<>();
        HashMap<String, ArrayList<Integer>> genresMap = new HashMap<>();

        // 1. 데이터 그룹화 (사용자께서 작성하신 부분 수정 반영)
        for(int i = 0; i < genres.length; i++) {
            genresTotalMap.put(genres[i], genresTotalMap.getOrDefault(genres[i], 0) + plays[i]);
            genresMap.computeIfAbsent(genres[i], k -> new ArrayList<>()).add(i);
        }

        // 2. 장르 이름(Key)들을 리스트로 추출하여 총 재생수 기준으로 정렬
        List<String> sortedGenreNames = new ArrayList<>(genresTotalMap.keySet());
        // 재생수(Value)를 비교하여 내림차순 정렬
        sortedGenreNames.sort((g1, g2) -> genresTotalMap.get(g2).compareTo(genresTotalMap.get(g1)));

        ArrayList<Integer> resultList = new ArrayList<>();

        // 3. 정렬된 장르 순서대로 순회하며 곡 추출
        for (String genre : sortedGenreNames) {
            ArrayList<Integer> songs = genresMap.get(genre);

            // 장르 내의 곡들을 문제 조건에 맞게 정렬
            songs.sort((a, b) -> {
                if (plays[a] == plays[b]) {
                    return a - b; // 3순위: 고유 번호 오름차순
                }
                return plays[b] - plays[a]; // 2순위: 재생 횟수 내림차순
            });

            // 최대 2곡까지 결과 리스트에 추가
            resultList.add(songs.get(0));
            if (songs.size() > 1) {
                resultList.add(songs.get(1));
            }
        }

        // 4. List를 int[] 배열로 변환
        int[] answer = new int[resultList.size()];
        for (int i = 0; i < resultList.size(); i++) {
            answer[i] = resultList.get(i);
        }

        return answer;
    }

    //-----------------------------------------------------------------

    static class Song implements Comparable<Song> {
        int id;
        int plays;

        public Song(int id, int plays) {
            this.id = id;
            this.plays = plays;
        }

        @Override
        public int compareTo(Song o) {
            if (this.plays == o.plays) {
                return this.id - o.id;
            }
            return o.plays - this.plays;
        }
    }

    public int[] solution2(String[] genres, int[] plays) {
        HashMap<String, Integer> genresTotalMap = new HashMap<>();
        HashMap<String, ArrayList<Song>> genresMap = new HashMap<>();

        for (int i=0; i < genres.length; i++) {
            genresTotalMap.put(genres[i], genresTotalMap.getOrDefault(genres[i], 0) + plays[i]);
            genresMap.computeIfAbsent(genres[i], k -> new ArrayList<Song>()).add(new Song(i, plays[i]));
        }

        ArrayList<String> sortedSongsList = new ArrayList<String>(genresTotalMap.keySet());
        sortedSongsList.sort((g1, g2) -> genresTotalMap.get(g2).compareTo(genresTotalMap.get(g1)));

        ArrayList<Integer> resultList = new ArrayList<Integer>();
        for (String song : sortedSongsList) {
            ArrayList<Song> songList = genresMap.get(song);
            Collections.sort(songList);

            resultList.add(songList.get(0).id);
            if (songList.size() > 1) {
                resultList.add(songList.get(1).id);
            }
        }

        return resultList.stream().mapToInt(i -> i).toArray();
    }

    //-----------------------------------------------------------------

    // 데이터를 담는 VO(Value Object) 클래스
    static class Song2 implements Comparable<Song2> {
        private final int id;
        private final String genre;
        private final int play;

        public Song2(int id, String genre, int play) {
            this.id = id;
            this.genre = genre;
            this.play = play;
        }

        public int getId() { return id; }
        public String getGenre() { return genre; }
        public int getPlay() { return play; }

        @Override
        public int compareTo(Song2 other) {
            if (this.play == other.play) {
                return Integer.compare(this.id, other.id); // ID 오름차순
            }
            return Integer.compare(other.play, this.play); // 재생수 내림차순
        }
    }

    public int[] solution3(String[] genres, int[] plays) {
        // 1. 데이터 소스 생성: 인덱스 스트림을 이용해 전체 곡 정보를 처리 가능한 형태로 변환
        return IntStream.range(0, genres.length)
                .mapToObj(i -> new Song2(i, genres[i], plays[i]))
                // 2. 장르별로 그룹화 (Map<String, List<Song>>)
                .collect(Collectors.groupingBy(Song2::getGenre))
                .entrySet().stream()
                // 3. 장르별 총 재생 횟수 기준 내림차순 정렬
                .sorted((a, b) -> {
                    int sumA = a.getValue().stream().mapToInt(Song2::getPlay).sum();
                    int sumB = b.getValue().stream().mapToInt(Song2::getPlay).sum();
                    return Integer.compare(sumB, sumA);
                })
                // 4. 각 장르 내에서 노래 정렬 후 최대 2개씩 추출
                .flatMap(entry -> entry.getValue().stream()
                        .sorted() // Song 클래스의 Comparable 적용 (재생수 내림차순, ID 오름차순)
                        .limit(2)
                )
                // 5. 최종적으로 고유 번호(ID)만 추출하여 배열로 변환
                .mapToInt(Song2::getId)
                .toArray();
    }
}
