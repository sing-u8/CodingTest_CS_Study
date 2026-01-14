# CodingTest Workspace (Java 17 + Node.js)

프로그래머스/백준/LeetCode 코딩 테스트 및 SQL 풀이를 **한 저장소**에서 정리하기 위한 템플릿입니다.

## 구성

- `java/`: Java 17(Gradle) 풀이/유틸
- `js/`: JavaScript(기본) 풀이/유틸 + (옵션) TypeScript 지원
- `sql/`: SQL 문제 풀이 + 스니펫
- `notes/`: 알고리즘/자료구조/디자인패턴 정리(MD)
- `samples/`: 로컬 실행용 샘플 입력

## 버전 고정 (mise)

이 프로젝트는 `mise`로 Node 버전을 고정합니다. (공식: [mise-en-place](https://mise.jdx.dev/))
- Node: **24.12.0 (LTS)**

```bash
mise install
```

## 폴더/파일 규칙(추천)

- **플랫폼별 풀이 경로**
  - Java: `java/src/main/java/platform/<platform>/...`
  - JS/TS: `js/src/platform/<platform>/...`
- **파일명**
  - 백준: `B_<문제번호>_<간단설명>.java|js|ts`
  - LeetCode: `LC_<문제번호>_<slug>.js|ts`
  - 프로그래머스: `P_<레벨>_<문제명>.js|java` (자유롭게 조정)
- **노트(MD)**
  - `notes/algorithms/`, `notes/data-structures/`, `notes/design-patterns/`
  - 각 노트에 “관련 코드 경로(상대경로)”를 같이 적기

## Java (IntelliJ)

- `java/`를 **Gradle 프로젝트**로 열면 됩니다. (Java Toolchain 17 고정)
- **가장 간단한 실행/디버그**: IntelliJ에서 각 문제 클래스의 `main()`을 직접 Run/Debug
- **CLI로 실행(선택)**: 로컬에 `gradle`이 설치되어 있다면:
  - `gradle -p java runSolution -Psolution=platform.baekjoon.B_0000_Template < samples/baekjoon/0000/input.txt`

## JavaScript (IntelliJ)

```bash
cd js
npm install
```

- 특정 파일 실행:
  - `node src/platform/baekjoon/B_0000_template.js < ../samples/baekjoon/0000/input.txt`
- 러너로 실행(디버그 편의):
  - `node src/runner.js platform/baekjoon/B_0000_template.js < ../samples/baekjoon/0000/input.txt`
- npm script로 실행:
  - `npm run solve -- platform/baekjoon/B_0000_template.js < ../samples/baekjoon/0000/input.txt`

## TypeScript(옵션)

- 기본은 JS로 풀이하고, 필요할 때만 `.ts`로 작성하세요.
- 실행:
  - `cd js`
  - `npx tsx src/runner.js platform/baekjoon/B_0000_template.ts < ../samples/baekjoon/0000/input.txt`

## 노트 작성 규칙(추천)

- `notes/**.md`에는:
  - 개념 설명
  - 관련 코드 링크(상대 경로)
  - 실전 문제(어떤 플랫폼/문제에서 썼는지)

