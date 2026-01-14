# Java (JDK 17)

- `src/main/java/platform/`: 플랫폼별 풀이
- `src/main/java/lib/`: 재사용 유틸(입출력, 그래프, 등)
- `src/main/java/runner/`: 선택 실행 러너(Gradle/CLI에서 편하게 실행)

## 실행

- IntelliJ에서 각 문제 클래스의 `main()`을 Run/Debug 하는 방식이 가장 간단합니다.
- CLI 실행(선택, 로컬에 `gradle` 필요):
  - `gradle -p java runSolution -Psolution=platform.baekjoon.B_0000_Template < samples/baekjoon/0000/input.txt`
