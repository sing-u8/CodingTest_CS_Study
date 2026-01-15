package platform.programmers.hash.의상;

import java.util.Arrays;
import java.util.HashMap;
import static java.util.stream.Collectors.*;

class Solution {
    public int solution(String[][] clothes) {
        return solution2(clothes);
    }

    private int solution1(String[][] clothes) {
        // 1. clothes 배열을 스트림으로 변환합니다.
        return Arrays.stream(clothes)
                // 2. Collectors.groupingBy를 사용하여 옷의 종류(c[1])별로 그룹화하고,
                //    각 그룹의 개수(Long)를 셉니다. (결과는 Map<String, Long> 형태)
                .collect(groupingBy(c -> c[1], counting()))
                // 3. 생성된 맵에서 값(옷의 개수)들만 가져와 새로운 스트림을 만듭니다.
                .values()
                .stream()
                // 4. 각 옷의 개수(count)에 1을 더하고(입지 않는 경우),
                //    모든 결과를 곱하여 전체 조합의 수를 계산합니다.
                .reduce(1L, (acc, count) -> acc * (count + 1))
                // 5. 최종 결과(Long)를 int로 변환하고, 알몸인 경우(1)를 뺍니다.
                .intValue() - 1;
    }

    private int solution2(String[][] clothes) {
        HashMap<String, Integer> clothesMap = new HashMap<>();
        Integer answer = 1;

        for (String[] clotheArr : clothes) {
            clothesMap.put(
                    clotheArr[1],
                    clothesMap.getOrDefault(clotheArr[1], 0) + 1
            );
        }

        for (Integer clothTypeNum : clothesMap.values()) {
            answer =  answer * (clothTypeNum + 1);
        }

        return answer - 1;
    }
}

/*

 */

