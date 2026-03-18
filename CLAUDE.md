# CodingTest_CS_Study — 프로젝트 가이드

## 목적
프로그래머스 / 백준 / LeetCode 알고리즘 문제 및 SQL 풀이를 한 저장소에서 정리하는 코딩 테스트 학습 프로젝트.

## 디렉토리 구조
```
.
├── java/          # Java 17 + Gradle 풀이
├── js/            # JavaScript / TypeScript 풀이
├── cpp/           # C++17 + Makefile 풀이
├── rust/          # Rust stable + Cargo 풀이
├── sql/           # SQL 풀이 + 스니펫
├── notes/         # 알고리즘/자료구조/디자인패턴 정리(MD)
└── samples/       # 로컬 실행용 샘플 입력
```

각 서브디렉토리에는 전용 `CLAUDE.md`가 있으며, 해당 언어/도구별 세부 규칙을 담고 있다.

## 파일 네이밍 컨벤션
| 플랫폼 | 패턴 | 예시 |
|--------|------|------|
| 백준 | `B_<문제번호>_<간단설명>.java\|js\|ts\|cpp\|rs` | `B_1197_최소스패닝트리.java` |
| LeetCode | `LC_<문제번호>_<slug>.js\|ts\|cpp\|rs` | `LC_0042_trapping-rain-water.js` |
| 프로그래머스 | `P_<레벨>_<문제명>.java\|js\|sql\|cpp\|rs` | `P_3_가장먼노드.java` |

## 스킬
- 알고리즘 문제 풀이·해설: `coding-test-mentor` 스킬 사용
- SQL 문제 풀이·해설: `sql-tutor` 스킬 사용
