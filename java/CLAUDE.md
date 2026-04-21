# java/ — Java 풀이 가이드

## 환경
- Java 17 + Gradle
- IntelliJ에서 `java/`를 Gradle 프로젝트로 열어 사용

## 새 문제 파일 위치
```
java/src/main/java/platform/<플랫폼>/<카테고리>/
```
예:
- `platform/leetcode/LC_0042_trapping-rain-water.java`
- `platform/programmers/greedy/P_3_큰수만들기.java`

## 파일 템플릿
```java
package platform.leetcode;

public final class LC_XXXX_slug {
    public static void main(String[] args) throws Exception {
        // 풀이
    }
}
```

## 유틸리티
- `lib/FastScanner.java` — 프로그래머스 stdin 기반 문제에서 빠른 입력이 필요할 때 재사용.
- 대량 출력 시 `StringBuilder` + `System.out.print()` 사용 (println 반복 금지)

## 실행
```bash
# CLI
gradle -p java runSolution -Psolution=platform.leetcode.LC_XXXX_slug
```

## 스킬
코딩 테스트 문제를 **풀거나 해설할 때** 반드시 `coding-test-mentor` 스킬을 사용한다.
