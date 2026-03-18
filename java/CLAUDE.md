# java/ — Java 풀이 가이드

## 환경
- Java 17 + Gradle
- IntelliJ에서 `java/`를 Gradle 프로젝트로 열어 사용

## 새 문제 파일 위치
```
java/src/main/java/platform/<플랫폼>/<카테고리>/
```
예:
- `platform/baekjoon/graph/B_1197_최소스패닝트리.java`
- `platform/programmers/greedy/P_3_큰수만들기.java`

## 파일 템플릿
```java
package platform.baekjoon;

import lib.FastScanner;

public final class B_XXXX_문제명 {
    public static void main(String[] args) throws Exception {
        FastScanner fs = new FastScanner();
        // 풀이
    }
}
```

## 유틸리티
- `lib/FastScanner.java` — 빠른 입력 처리. 새 문제에서 항상 재사용할 것.
- 대량 출력 시 `StringBuilder` + `System.out.print()` 사용 (println 반복 금지)

## 실행
```bash
# CLI
gradle -p java runSolution -Psolution=platform.baekjoon.B_XXXX_문제명 < samples/baekjoon/XXXX/input.txt
```

## 스킬
코딩 테스트 문제를 **풀거나 해설할 때** 반드시 `coding-test-mentor` 스킬을 사용한다.
