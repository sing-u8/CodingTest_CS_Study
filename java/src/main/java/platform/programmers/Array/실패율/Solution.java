import java.util.HashMap;

class Solution {
	public int[] solution(int N, int[] stages) {

		// [1단계] 카운팅 배열: 각 스테이지에 멈춰있는 플레이어 수 집계
		int[] challenger = new int[N + 2];
		for (int stage : stages) {
			challenger[stage] += 1;
		}

		// [2단계] 실패율 계산: HashMap에 (스테이지 번호 → 실패율) 저장
		HashMap<Integer, Double> fails = new HashMap<>();
		double total = stages.length; // 도달한 누적 인원 (double로 선언하여 자동 실수 나눗셈)

		for (int i = 1; i <= N; i++) {
			if (challenger[i] == 0) {
				// 해당 스테이지에 멈춘 사람이 없으면 실패율 0
				fails.put(i, 0.);
			} else {
				// 실패율 = 멈춘 수 / 도달한 수
				fails.put(i, challenger[i] / total);
				// 다음 스테이지 도달 인원 차감
				total -= challenger[i];
			}
		}

		// [3단계] Stream 정렬: 실패율 내림차순, 동률 시 번호 오름차순
		return fails.entrySet().stream().sorted((o1, o2) ->
				o1.getValue().equals(o2.getValue())
					? Integer.compare(o1.getKey(), o2.getKey())
					: Double.compare(o2.getValue(), o1.getValue()))
			.mapToInt(HashMap.Entry::getKey).toArray();
	}
}