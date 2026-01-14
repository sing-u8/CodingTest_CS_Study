package runner;

/**
 * IntelliJ에서는 보통 각 문제 클래스의 main()을 직접 Run/Debug 하는 것이 가장 편합니다.
 * 그래도 Gradle로 실행하고 싶으면 `runSolution` 태스크를 사용하세요.
 *
 * 예)
 *   ./gradlew -p java runSolution -Psolution=platform.baekjoon.B_0000_Template < samples/baekjoon/0000/input.txt
 */
public final class Runner {
    public static void main(String[] args) {
        System.out.println("Use Gradle task `runSolution` with -Psolution=... or run each solution main() in IntelliJ.");
    }
}

