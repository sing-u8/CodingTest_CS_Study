# BNK시스템 코딩 역량 진단 및 복습 계획

> 기준일: 2026-07-19  
> 기준 문서: [BNK시스템 AI역량검사·코딩테스트 준비 계획](BNK_System-공채준비.md)  
> 분석 범위: 현재 작업공간의 Java·SQL 프로그래머스 풀이와 복습 노트  
> 전제: 프로그래머스 알고리즘·SQL 고득점 Kit를 모두 한 번씩 풀었고, 저장소에는 다시 볼 필요가 있는 문제를 선별해 두었다.

## 바로 가기

- [현재 수준과 공백기 복귀 방식](#2-저장소-기준-학습-현황)
- [Java 진단·Collections·알고리즘 템플릿](#3-java-진단)
- [SQL 진단·문법·풀이 템플릿](#4-sql-진단)
- [7월 19~24일 실행 순서](#5-7월-1924일-실행-계획)
- [AI역량검사 자료·YouTube·최소 준비량](#6-ai역량검사-자료-분석과-최소-준비량)
- [최종 체크포인트](#8-최종-체크포인트)

## 1. 결론

현재는 **새 범위를 더 넓힐 단계가 아니라, 이미 접한 문제를 제한시간 안에 다시 만들어 내는 단계**다.

- 알고리즘·SQL의 **범위 학습은 상당 부분 완료**됐다.
- SQL은 BNK 예상 난도보다 높은 문제까지 다뤄 **범위가 충분하다**.
- Java도 여러 알고리즘을 경험했지만, 일부 저장 코드가 컴파일되지 않거나 정답 진입점이 비효율 풀이를 호출한다. 따라서 **실전 재현 안정성은 아직 검증이 필요**하다.
- BNK 대비 효율만 보면 고급 DP·복잡한 그래프를 더 공부하는 것보다 **구현·해시·그리디·기초 스택과 SQL JOIN·집계·NULL·날짜 반례**를 다시 푸는 편이 낫다.
- AI역량검사는 답변 설계가 끝난 상태일 뿐, 이 저장소에는 녹화·모의 결과가 없으므로 **실전 준비도는 아직 판정할 수 없다**.

즉, 현재 위치는 다음과 같다.

| 단계 | 상태 | 판단 |
|---|---|---|
| 1. 유형을 접해 봄 | 완료 | 고득점 Kit 전체 1회 풀이 |
| 2. 해설을 읽고 원리를 이해함 | 상당 부분 완료 | 상세 풀이·보충 질문이 남아 있음 |
| 3. 다음 날 빈 화면에서 재구현 | 미확인 | 저장소만으로 검증 불가 |
| 4. 제한시간 내 연속 풀이 | 미확인 | 2시간 모의 기록 없음 |
| 5. 반례까지 설명하고 제출 | 부분 완료 | 노트에는 있으나 실전 재현 여부 미확인 |

**합격 가능성을 높이는 마지막 작업은 3~5단계를 검증하는 것**이다.

## 2. 저장소 기준 학습 현황

### 2.1 정량 현황

| 영역 | 확인된 내용 | 해석 |
|---|---:|---|
| Java 문제 | 32개 문제 디렉터리 | 구현부터 Lv5 그래프까지 범위가 넓음 |
| Java 소스 | 36개 `Solution*.java` | 여러 풀이를 비교한 문제 포함 |
| Java 유형 | 9개 | Array, Binary Search, Brute Force, DFS/BFS, DP, Graph, Greedy, Hash, Stack |
| Java 개별 컴파일 | 31/36 성공 | 5개 소스는 현재 상태로 컴파일 실패 |
| Java 풀이 노트 | 41개, 약 15,236줄 | 이해 자료는 충분하지만 시험 직전 복습량으로는 과다 |
| SQL 문제 | 30개 | Lv1 3, Lv2 7, Lv3 7, Lv4 11, Lv5 2 |
| SQL 풀이 파일 | 약 3,936줄 | 정답·대안·과거 오답·장문 해설이 한 파일에 함께 있음 |
| 자동 테스트 | 확인되지 않음 | 통과 이력과 현재 코드의 일치 여부를 보장하지 못함 |

현재 작업공간에서 새로 추가된 Stack 5문제도 분석에 포함했다. 아직 Git에 추적되지 않은 상태이므로 시험 후 정리할 때 누락하지 않도록 한다.

### 2.2 현재 수준에 대한 판정

#### Java

- **유형 인지 범위:** 충분
- **Lv1~2 기본 문제 경험:** 충분
- **Lv3 이상 확장 경험:** 충분 이상
- **Java 문법·컬렉션 사용 경험:** 있음
- **시험장에서의 안정성:** 추가 검증 필요

Java는 “모르는 알고리즘이 많아서 위험한 상태”가 아니다. 오히려 여러 버전의 코드와 긴 해설이 함께 있어, 시험장에서 사용할 **한 가지 표준 풀이가 고정되지 않은 것**이 더 큰 위험이다.

#### SQL

- **기본 조회·정렬·날짜 출력:** 충분
- **JOIN·GROUP BY·HAVING:** 충분
- **CTE·서브쿼리·윈도우 함수:** 충분 이상
- **재귀 CTE·비트 마스크:** BNK 예상 범위보다 높은 수준까지 경험
- **NULL·OUTER JOIN 반례의 즉시 재현:** 집중 검증 필요

SQL은 문제 난도보다 **결과 집합의 기준 행(grain), JOIN 후 중복, 0건과 NULL을 정확히 설명할 수 있는지**가 합격을 가를 가능성이 높다.

#### AI역량검사

[기준 문서](BNK_System-공채준비.md)에 질문별 사례, 금지할 과장 표현, 답변 구조, JOBDA 대비가 이미 정리돼 있다. 그러나 다음 증거는 저장소에서 확인되지 않는다.

- 45~60초 답변 녹화 결과
- 90초 답변 녹화 결과
- 서류와 달라진 표현을 기록한 오답표
- 90분 전체 모의 결과

따라서 AI역량검사는 **계획 수립 완료, 수행 여부 미확인**으로 본다.

### 2.3 코테 공백기를 반영한 복귀 순서

개인 프로젝트를 하느라 코테를 쉬었다면, 처음부터 2시간 모의를 보는 것보다 **문법 손풀기 → 한 유형 한 문제 → 혼합 모의** 순서가 빠르고 정확하다. 알고리즘을 새로 배우는 상태가 아니라, 알고 있던 지식을 다시 꺼내는 상태이기 때문이다.

| 단계 | 할 일 | 통과 기준 | 다음 단계 |
|---|---|---|---|
| 1. 손 감각 복구 | 아래 Java·SQL 템플릿을 보지 않고 다시 입력 | 컴파일·실행되고 각 줄의 이유를 설명 | 대표 문제로 이동 |
| 2. 유형 회수 | 구현·해시·그리디·스택·BFS와 SQL JOIN·집계를 유형별 1문제씩 풀이 | 제한시간 안에 무해설 통과 | 혼합 세트로 이동 |
| 3. 반례 고정 | 틀린 문제마다 최소·경계·중복·NULL 반례 작성 | 왜 틀렸는지 한 문장으로 설명 | 다음 날 재풀이 |
| 4. 다음 날 재현 | 정답을 보지 않고 같은 문제 다시 풀이 | 첫 시도보다 빠르고 같은 실수 0건 | 복습 완료 표시 |
| 5. 실전 전환 | Java와 SQL을 섞어 2시간 연속 풀이 | 10분 스캔, 3문제 이상 통과, 마지막 15분 검증 | 시험 운영 확정 |

첫날 점수가 낮아도 실력 전체가 사라진 것으로 해석하지 않는다. 다음을 구분해 기록한다.

- **문법 회수 실패:** `computeIfAbsent`, Comparator, 날짜 함수 등이 떠오르지 않음
- **유형 판별 실패:** 최단거리인데 DFS를 시작함
- **구현 실패:** 인덱스·방문 처리·NULL 필터 위치를 틀림
- **검증 실패:** 정답 접근인데 경계 반례를 놓침

이 구분을 해야 AI에게도 “설명해 줘”가 아니라 정확한 도움을 요청할 수 있다.

### 2.4 AI 도움을 쓰되 실력을 남기는 규칙

AI를 쓰는 목적은 정답을 빨리 얻는 것이 아니라 **막힌 원인을 빨리 특정하고, 다음 날 혼자 재현하는 것**이다.

#### 문제당 Red → Amber → Green 절차

1. **Red — 무도움 풀이**
   - Java Lv1 25분, Lv2 35~45분, SQL 기본 20분, JOIN·집계 30~35분까지 혼자 푼다.
   - 문제 조건, 예상 복잡도, 자료구조, 반례를 먼저 적는다.
2. **Amber — 한 단계 힌트**
   - 전체 코드와 완성 쿼리를 요구하지 않는다.
   - “내 접근에서 첫 번째로 잘못된 가정 하나” 또는 “다음에 확인할 조건 하나”만 묻는다.
3. **Green — 제출 후 검증**
   - 플랫폼 통과 후 코드 리뷰, 복잡도, 반례 5개, 더 단순한 표준 풀이를 요청한다.
   - AI 설명과 저장소 코드는 참고자료이고, 최종 판정은 **직접 실행 결과와 플랫폼 채점**으로 한다.
4. **다음 날 — 백지 재풀이**
   - AI 대화를 닫고 같은 문제를 다시 푼다.
   - 이것까지 통과해야 복습 완료다.

바로 복사해 쓸 프롬프트:

```text
[힌트 모드]
정답 코드나 완성된 의사코드는 주지 마.
내 접근에서 가장 먼저 틀린 가정 하나만 질문 형태로 알려 줘.
내가 답하면 다음 힌트를 한 단계만 줘.
문제: ...
내 접근: ...
```

```text
[Java 검증 모드]
아래 Java 17 풀이를 ① 컴파일 위험 ② 정답성 ③ 시간·공간복잡도
④ 최소/경계/중복/overflow 반례 순서로 검토해 줘.
수정 코드는 먼저 주지 말고, 실패하는 최소 입력부터 보여 줘.
```

```text
[SQL 검증 모드]
MySQL 8 기준으로 이 쿼리의 결과 한 행의 의미(grain)를 먼저 정의해 줘.
JOIN 전후 예상 행 수, NULL 보존, 날짜 경계, 중복 집계를 검사하고
오답이면 5행 이내의 최소 반례 데이터만 먼저 만들어 줘.
완성 쿼리는 내가 요청할 때만 보여 줘.
```

```text
[회상 퀴즈 모드]
방금 푼 문제의 정답은 말하지 말고 한 번에 한 질문씩 퀴즈를 내 줘.
유형 트리거 → 핵심 불변식 → 시간복잡도 → 반례 → Java/SQL 문법 순서로 물어봐.
내 답이 부정확하면 빠진 한 항목만 지적해 줘.
```

AI가 만든 반례도 틀릴 수 있다. 직접 손으로 추적하거나 작은 입력을 실행해 확인한 반례만 오답 카드에 남긴다.

### 2.5 응시 언어 결정 — Java로 고정

이번 코딩테스트의 주력 언어는 **Java**로 고정한다.

근거:

- 현재 저장소에 Java 문제 32개, `Solution*.java` 36개와 유형별 오답 노트가 남아 있다.
- `HashMap`, `HashSet`, `ArrayDeque`, 정렬, BFS·DFS 등 코테 핵심 구현 경험이 Java에 축적돼 있다.
- 공백기 직후에는 언어를 바꾸는 것보다 이미 아는 알고리즘을 Java 문법으로 다시 꺼내는 편이 빠르고 안정적이다.
- BNK시스템 IT개발 채용공고의 보유 기술에도 JAVA가 명시돼 있다. 다만 이것은 코딩시험의 지원 언어 목록을 뜻하지는 않는다.

따라서 시험 전에는 JavaScript 등 다른 언어를 병행하지 않는다. 이 문서의 컬렉션·알고리즘 템플릿도 모두 Java 17 기준으로 사용한다.

초대 안내가 오면 다음 네 가지만 확인한다.

1. Java 지원 여부와 버전
2. 프로그래머스형 `solution` 메서드인지, 표준입출력형 `main`인지
3. 사용할 수 있는 표준 라이브러리와 자동완성 제공 여부
4. SQL 제공 방언이 MySQL인지 Oracle인지

Java 버전이 17보다 낮아도 현재 템플릿은 `record`, `var`, 최신 전용 API를 사용하지 않으므로 대부분 그대로 쓸 수 있다. 실제 플랫폼에서 Java가 지원되지 않는 예외적인 경우에만 대체 언어를 결정한다.

## 3. Java 진단

### 3.1 잘 진행된 부분

1. **문제 유형을 자료구조와 연결하는 경험이 있다.**
   - `방문 길이`: 점이 아니라 간선을 `Set`으로 관리
   - `실패율`: 카운팅 배열과 다중 정렬 기준
   - `베스트앨범`: 해시 그룹화 후 그룹·원소 각각 정렬
   - `주식가격`: 단조 스택
2. **최단거리·연결요소·백트래킹을 구분해 본 흔적이 있다.**
   - BFS와 DFS를 여러 버전으로 비교했다.
   - `아이템 줍기`, `여행경로`, `퍼즐 조각 채우기`에는 별도 질문 노트가 있다.
3. **고급 문제까지 원리를 학습했다.**
   - Parametric Search, 구간 DP, MST, 플로이드-워셜, 오일러 경로, 좌표 정규화까지 포함한다.
4. **경계조건을 노트로 남기는 습관이 있다.**
   - 0명인 실패율, 도착점 간격, 원형 DP 분리, 좌표 2배 확대 등이 문서화돼 있다.

### 3.2 지금 바로 보완할 위험

개별 파일을 `javac 17`로 확인한 결과 36개 중 5개가 컴파일되지 않았다.

| 파일 | 현재 문제 | 복습 시 조치 |
|---|---|---|
| [단어 변환](<../../java/src/main/java/platform/programmers/DFS&BFS/단어_변환/Solution.java>) | 파일 중간 `import`, 존재하지 않는 `DFS_solution` 호출 | BFS 한 버전만 빈 화면에서 작성 |
| [여행경로 Solution1](<../../java/src/main/java/platform/programmers/DFS&BFS/여행경로/Solution1.java>) | 파일 중간 `import`, 같은 이름의 `Solution` 중복 | 백트래킹 또는 Solution2 중 하나만 선택 |
| [N으로 표현](<../../java/src/main/java/platform/programmers/DP/N으로_표현/Solution.java>) | 공백이 든 잘못된 package 문 | 알고리즘보다 제출 가능한 단일 코드 형태 점검 |
| [섬 연결하기](<../../java/src/main/java/platform/programmers/Greedy/섬_연결하기/Solution.java>) | 잘못된 package, 메서드 안 `static` 선언, 중첩된 `solution` | BNK 전에는 후순위, 시험 후 구조 정리 |
| [조이스틱](<../../java/src/main/java/platform/programmers/Greedy/조이스틱/Solution.java>) | 반복 변수 `ch` 대신 없는 변수 `c` 사용 | 그리디 상위 Lv2 보험 문제로 1회 재작성 |

컴파일은 되지만 실전 기준으로 더 중요한 문제도 있다.

- [게임 맵 최단거리](<../../java/src/main/java/platform/programmers/DFS&BFS/게임_맵_최단거리/Solution.java>)의 기본 `solution()`은 “효율성 0점”이라고 적힌 DFS를 호출한다. 이 문제는 **무가중치 최단거리 → BFS**가 즉시 나와야 한다.
- 여러 파일이 기본 패키지의 같은 `Solution` 이름을 사용하므로 저장소 전체를 한 번에 빌드하는 구조와 맞지 않는다. 프로그래머스 제출에는 문제가 없지만, 로컬 회귀 검증에는 불리하다.
- 정답·대안·학습용 코드가 한 파일에 섞여 있다. 시험 전에는 문제마다 **제출용 한 버전**만 선택해야 한다.
- 해설이 매우 길어 다시 읽는 데 시간이 많이 든다. 해설 재독보다 3줄 회상 카드를 만드는 편이 낫다.

### 3.3 BNK 우선순위로 다시 배열한 Java 문제

#### P0 — 시험 전 반드시 빈 화면 재풀이

| 문제 | 복습할 원리 | 통과 기준 |
|---|---|---|
| [실패율](<../../java/src/main/java/platform/programmers/Array/실패율/Solution.java>) | 카운팅, 분모 감소, 0명 처리, 2차 정렬 | 30분 안에 통과하고 분모 0 반례 설명 |
| [방문 길이](<../../java/src/main/java/platform/programmers/Array/방문 길이/Solution.java>) | 좌표 경계, 점과 간선의 차이, 무방향 간선 정규화 | 예제 없이 역방향 중복 이유 설명 |
| [큰 수 만들기](<../../java/src/main/java/platform/programmers/Greedy/큰_수_만들기/Solution.java>) | 앞자리 최적화, 단조 스택, 남은 `k` 처리 | 35분 안에 통과하고 끝자리 삭제 반례 확인 |
| [조이스틱](<../../java/src/main/java/platform/programmers/Greedy/조이스틱/Solution.java>) | 문자 순환, 연속 A 구간, 양방향 전환 비용 | 코드 오타 없이 45분 안에 재작성 |
| [의상](<../../java/src/main/java/platform/programmers/Hash/의상/Solution.java>) | 빈도 Map, 곱의 법칙, 선택하지 않음과 전체 미선택 제외 | 수식 `(count+1)`과 마지막 `-1` 설명 |
| [베스트앨범](<../../java/src/main/java/platform/programmers/Hash/베스트앨범/Solution.java>) | 그룹 합계, 그룹 정렬, 그룹 내부 정렬, 동점 | Comparator 기준을 말로 먼저 정리 |
| [괄호 회전하기](<../../java/src/main/java/platform/programmers/Stack/괄호_회전하기/Solution.java>) | 스택, 괄호 짝, 회전을 `s+s` 구간으로 표현 | 홀수 길이·빈 스택 반례 확인 |
| [주식가격](<../../java/src/main/java/platform/programmers/Stack/주식가격/Solution.java>) | 인덱스 단조 스택, 미해결 원소 후처리 | 각 인덱스가 한 번 push/pop됨을 설명 |
| [크레인 인형뽑기](<../../java/src/main/java/platform/programmers/Stack/크레인_인형뽑기_게임/Solution.java>) | 1→0 인덱스 변환, 시뮬레이션, 스택 | 25분 안에 통과 |
| [게임 맵 최단거리](<../../java/src/main/java/platform/programmers/DFS&BFS/게임_맵_최단거리/Solution.java>) | 무가중치 최단거리 BFS, 방문 시점 | DFS 코드를 보지 않고 BFS 한 버전 작성 |

P0에는 저장소 밖의 다음 BNK 직접 대비 문제도 포함한다.

- `공원 산책`
- `개인정보 수집 유효기간`
- `달리기 경주`
- `구명보트`
- `요격 시스템`
- `광물 캐기`
- `할인 행사`
- `귤 고르기`
- `점프와 순간 이동`

이 문제들은 이미 한 번 풀었으므로 새로운 학습이 아니라 **시간 제한 재검증**으로 다룬다.

#### P1 — P0가 안정된 뒤 보험용으로 복습

| 묶음 | 문제 | 복습 원리 |
|---|---|---|
| DFS/BFS 기초 | `네트워크`, `타겟 넘버`, `단어 변환` | 연결요소, 상태 트리, 최단거리의 BFS 선택 |
| 완전탐색 | `소수 찾기`, `전력망을 둘로 나누기` | 순열·중복 제거·백트래킹, 간선 하나 제거 후 탐색 |
| 기초 DP | `정수 삼각형`, `등굣길` | 상태 정의, 경계 초기화, 이전 상태 전이 |
| 이분 탐색 | `입국심사` | 정답값 이분 탐색, 단조성, `long` |
| 연결 리스트 응용 | `표 편집` | 배열 기반 이전·다음 포인터와 삭제 복원 |

#### P2 — 이번 BNK 시험 이후에 복습

- `징검다리`
- `아이템 줍기`
- `여행경로`
- `퍼즐 조각 채우기`
- `N으로 표현`
- `도둑질`
- `사칙연산`
- `가장 먼 노드`
- `순위`
- `방의 개수`
- `섬 연결하기`

중요한 문제들이지만, 6일 안에 BNK 예상 유형을 대비하는 효율은 낮다. P0·SQL·AI 모의를 끝내기 전에는 열지 않는다.

### 3.4 Java에서 암기할 것이 아니라 재현할 원리

1. **입력 크기 → 허용 복잡도**를 먼저 정한다.
2. 문제의 상태가 무엇인지 정한다.
   - 위치인가?
   - 마지막까지 해결되지 않은 인덱스인가?
   - 사용한 티켓인가?
   - 특정 개수의 N으로 만들 수 있는 결과 집합인가?
3. 최단거리에서 모든 간선의 비용이 같으면 BFS를 먼저 검토한다.
4. 그리디는 “지금 선택이 최적인 이유”와 “나중 선택을 막지 않는 이유”를 한 문장으로 말한다.
5. 정렬 문제는 Comparator를 쓰기 전에 1차·2차·3차 기준을 적는다.
6. 좌표 문제는 `row/col` 또는 `x/y` 중 하나를 정하고 끝까지 유지한다.
7. 누적 합계·경우의 수·정답 상한이 `int`를 넘는지 확인한다.
8. `Stack`보다 `ArrayDeque`를 기본으로 사용하되, 익숙한 API로 실수를 줄이는 것을 우선한다.

### 3.5 Java 17 Collections 실전 치트시트

Java 17 기준으로 아래 문법은 검색 없이 써야 한다. Oracle도 스택에는 예전 `Stack`보다 `Deque` 구현체를 권장하고, `ArrayDeque`는 대부분의 스택·큐 용도에 적합하다고 설명한다.

- [ArrayDeque API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/ArrayDeque.html)
- [HashMap API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/HashMap.html)
- [HashSet API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/HashSet.html)
- [PriorityQueue API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/PriorityQueue.html)
- [Arrays API](https://docs.oracle.com/en/java/javase/17/docs/api/java.base/java/util/Arrays.html)

기본 import:

```java
import java.util.*;
```

#### `Set` — 존재 여부·중복 제거

```java
Set<String> seen = new HashSet<>();

boolean first = seen.add("A-B"); // 처음 추가면 true, 이미 있으면 false
boolean exists = seen.contains("A-B");
seen.remove("A-B");
int uniqueCount = seen.size();
```

사용 트리거:

- “서로 다른 개수”
- “이미 방문했는가”
- “같은 조합·경로를 한 번만”

주의:

- `HashSet`의 순서는 보장되지 않는다.
- 좌표나 간선은 문자열로 합치기 전에 정규화한다.
- 무방향 간선 `(a,b)`와 `(b,a)`를 같게 보려면 작은 값을 먼저 둔다.

```java
static String edgeKey(int r1, int c1, int r2, int c2) {
    String a = r1 + "," + c1;
    String b = r2 + "," + c2;
    return a.compareTo(b) <= 0 ? a + "|" + b : b + "|" + a;
}
```

#### `Map` — 빈도·그룹·키에서 값 찾기

```java
Map<String, Integer> count = new HashMap<>();

for (String key : values) {
    count.put(key, count.getOrDefault(key, 0) + 1);
    // 같은 의미: count.merge(key, 1, Integer::sum);
}

for (Map.Entry<String, Integer> entry : count.entrySet()) {
    String key = entry.getKey();
    int value = entry.getValue();
}
```

그룹별 목록:

```java
Map<String, List<Integer>> group = new HashMap<>();

for (int i = 0; i < genres.length; i++) {
    group.computeIfAbsent(genres[i], k -> new ArrayList<>()).add(i);
}
```

그래프 인접 리스트:

```java
int n = 5;
List<List<Integer>> graph = new ArrayList<>();
for (int i = 0; i < n; i++) graph.add(new ArrayList<>());

graph.get(a).add(b);
graph.get(b).add(a); // 무방향 그래프일 때
```

주의:

- `map.get(key) == null`은 “키가 없음”과 “값이 null”을 구분하지 못한다. 구분해야 하면 `containsKey`를 쓴다.
- 정답 순서가 필요하면 `HashMap` 순회에 기대지 말고 키를 따로 정렬한다.

#### `Deque` — 큐와 스택

큐로 쓸 때:

```java
Deque<int[]> queue = new ArrayDeque<>();
queue.offer(new int[]{0, 0}); // 뒤에 삽입
int[] current = queue.poll(); // 앞에서 제거, 비어 있으면 null
int[] next = queue.peek();    // 앞을 확인, 제거하지 않음
```

스택으로 쓸 때:

```java
Deque<Integer> stack = new ArrayDeque<>();
stack.push(3);       // 앞에 삽입
int top = stack.peek();
int value = stack.pop();
```

한 문제 안에서는 `offer/poll`과 `push/pop` 스타일을 섞지 않는다. `ArrayDeque`에는 `null`을 넣지 않는다.

#### `PriorityQueue` — 지금 가장 작은 값·큰 값 꺼내기

```java
PriorityQueue<Integer> minHeap = new PriorityQueue<>();
PriorityQueue<Integer> maxHeap =
        new PriorityQueue<>(Comparator.reverseOrder());

minHeap.offer(4);
minHeap.offer(1);
int min = minHeap.poll(); // 1
```

배열 원소의 다중 정렬:

```java
// {비용, 노드}; 비용 오름차순, 동점이면 노드 오름차순
PriorityQueue<int[]> pq = new PriorityQueue<>(
        Comparator.<int[]>comparingInt(x -> x[0])
                .thenComparingInt(x -> x[1])
);
```

Comparator에서 `a[0] - b[0]`은 overflow 위험이 있으므로 `Integer.compare`나 `comparingInt`를 쓴다.

#### 배열·리스트 정렬

```java
int[] numbers = {3, 1, 2};
Arrays.sort(numbers); // 기본형 배열 오름차순

Integer[] boxed = {3, 1, 2};
Arrays.sort(boxed, Comparator.reverseOrder());

List<int[]> rows = new ArrayList<>();
rows.sort(
        Comparator.<int[]>comparingInt(x -> x[0])
                .thenComparing((a, b) -> Integer.compare(b[1], a[1]))
);
```

정렬 코드를 쓰기 전에 다음처럼 기준부터 적는다.

```text
1차: 총 재생 수 내림차순
2차: 곡 재생 수 내림차순
3차: 고유번호 오름차순
```

#### 자주 잊는 기본 문법

```java
String s = "abc";
char ch = s.charAt(0);
char[] chars = s.toCharArray();
String part = s.substring(1, 3); // index 1 이상, 3 미만

StringBuilder sb = new StringBuilder();
sb.append("ab").append(3);
sb.deleteCharAt(sb.length() - 1);
String result = sb.toString();

List<Integer> list = new ArrayList<>();
list.add(10);
list.remove(0);                 // index 0 삭제
list.remove(Integer.valueOf(10)); // 값 10 삭제

long product = (long) a * b;    // 곱하기 전에 long으로 승격
```

### 3.6 시험장에서 꺼내 쓸 알고리즘 템플릿

템플릿을 통째로 암기하기보다 **초기 상태, 반복 중 불변식, 종료 후 남은 원소 처리**를 기억한다. 7월 19~20일에는 아래 코드를 하루 한 번씩 빈 파일에 다시 입력한다.

#### 1. 격자 BFS — 무가중치 최단거리

```java
static int bfs(int[][] map) {
    int n = map.length;
    int m = map[0].length;
    int[] dr = {-1, 1, 0, 0};
    int[] dc = {0, 0, -1, 1};

    if (map[0][0] == 0) return -1;

    int[][] dist = new int[n][m];
    for (int[] row : dist) Arrays.fill(row, -1);

    Deque<int[]> queue = new ArrayDeque<>();
    queue.offer(new int[]{0, 0});
    dist[0][0] = 1; // 큐에 넣을 때 방문 처리

    while (!queue.isEmpty()) {
        int[] cur = queue.poll();
        int r = cur[0];
        int c = cur[1];

        for (int d = 0; d < 4; d++) {
            int nr = r + dr[d];
            int nc = c + dc[d];

            if (nr < 0 || nr >= n || nc < 0 || nc >= m) continue;
            if (map[nr][nc] == 0 || dist[nr][nc] != -1) continue;

            dist[nr][nc] = dist[r][c] + 1;
            queue.offer(new int[]{nr, nc});
        }
    }

    return dist[n - 1][m - 1];
}
```

핵심: 방문 처리를 `poll`할 때가 아니라 **큐에 넣을 때** 해야 같은 칸이 중복 삽입되지 않는다.

#### 2. 그래프 DFS — 연결요소

```java
static void dfs(int node, List<List<Integer>> graph, boolean[] visited) {
    visited[node] = true;

    for (int next : graph.get(node)) {
        if (!visited[next]) {
            dfs(next, graph, visited);
        }
    }
}

static int countComponents(List<List<Integer>> graph) {
    boolean[] visited = new boolean[graph.size()];
    int count = 0;

    for (int node = 0; node < graph.size(); node++) {
        if (!visited[node]) {
            dfs(node, graph, visited);
            count++;
        }
    }
    return count;
}
```

백트래킹이면 재귀 호출 뒤에 선택 상태를 반드시 복원한다.

```java
used[i] = true;
pick[depth] = values[i];
search(depth + 1);
used[i] = false; // 상태 복원
```

#### 3. 정렬 + 투 포인터 — 양끝에서 결정

```java
Arrays.sort(values);
int left = 0;
int right = values.length - 1;
int answer = 0;

while (left <= right) {
    if (left == right) {
        answer++;
        break;
    }

    if (values[left] + values[right] <= limit) {
        left++;
    }
    right--;
    answer++;
}
```

`구명보트`처럼 가장 무거운 원소를 반드시 처리하면서, 가장 가벼운 원소와 함께 보낼 수 있는지를 결정하는 유형이다.

#### 4. 단조 스택 — 아직 답이 정해지지 않은 인덱스

```java
int n = prices.length;
int[] answer = new int[n];
Deque<Integer> stack = new ArrayDeque<>();

for (int i = 0; i < n; i++) {
    while (!stack.isEmpty() && prices[stack.peek()] > prices[i]) {
        int prev = stack.pop();
        answer[prev] = i - prev;
    }
    stack.push(i);
}

while (!stack.isEmpty()) {
    int prev = stack.pop();
    answer[prev] = n - 1 - prev;
}
```

스택에는 값보다 **정답을 써야 하는 인덱스**를 넣는 경우가 많다.

#### 5. 정답값 이분 탐색 — 가능한 최소값

```java
long left = 0;
long right = upperBound;

while (left < right) {
    long mid = left + (right - left) / 2;

    if (canFinish(mid)) {
        right = mid;
    } else {
        left = mid + 1;
    }
}

long answer = left;
```

적용 전에 “시간 `x`가 가능하면 `x`보다 큰 시간도 모두 가능한가?”처럼 단조성을 한 문장으로 증명한다. 상한과 누적 처리량은 `long`으로 둔다.

#### 6. 1차원 DP — 상태와 초기값부터

```java
long[] dp = new long[n + 1];
dp[0] = initialValue;

for (int i = 1; i <= n; i++) {
    // dp[i] = 이전에 이미 계산된 상태들로 갱신
}
```

코드보다 먼저 적을 세 문장:

```text
dp[i]는 무엇을 의미하는가?
dp[0] 또는 첫 행·첫 열의 초기값은 무엇인가?
dp[i]를 만들 때 참조하는 더 작은 상태는 무엇인가?
```

#### 7. 유형 선택 30초 체크

| 문제 표현 | 첫 후보 |
|---|---|
| 존재·중복·서로 다른 개수 | `HashSet` |
| 종류별 개수·키별 합계·그룹 | `HashMap` |
| 무가중치 최단거리 | BFS + `ArrayDeque` |
| 연결요소·모든 조합 | DFS/백트래킹 |
| 가장 작은/큰 것을 반복 선택 | 정렬 또는 `PriorityQueue` |
| 이전의 미해결 원소를 현재가 해결 | 단조 스택 |
| 정답 범위가 크고 가능 여부가 단조 | 정답값 이분 탐색 |
| 같은 작은 상태를 반복 계산 | DP |

## 4. SQL 진단

### 4.1 잘 진행된 부분

저장된 30문제는 BNK 예상 범위를 충분히 덮는다.

| 역량 | 대표 문제 |
|---|---|
| 날짜 범위·포맷 | `조건에 맞는 회원수`, `조건에 맞는 도서 리스트` |
| GROUP BY·HAVING | `대여 횟수가 많은 자동차들의 월별 대여 횟수` |
| 셀프 JOIN·0건 집계 | `대장균들의 자식의 수` |
| 그룹별 최대 행 | `즐겨찾기가 가장 많은 식당`, `물고기 종류별 대어` |
| 고정 분모·중복 사용자 | `상품을 구매한 회원 비율` |
| 데이터 세로 결합 | `온라인·오프라인 판매 데이터 통합`, `주문량이 많은 아이스크림` |
| 날짜 겹침 | `특정 기간 대여 가능한 자동차` |
| NULL 대체·조건부 집계 | `특정 조건을 만족하는 물고기별 수와 최대 길이` |
| 윈도우 함수 | `대장균 크기 분류 2`, `연도별 크기 편차` |
| 비트 마스크 | `조건에 맞는 개발자`, `언어별 개발자 분류` |
| 재귀 CTE | `특정 세대`, `멸종 위기의 대장균` |

특히 재귀 CTE·윈도우 함수·비트 연산은 BNK 대비 필수 범위라기보다 상위 보험에 가깝다. 새로운 고난도 SQL을 추가할 필요는 없다.

### 4.2 지금 보완할 위험

1. **BNK 핵심 반례와 정확히 같은 연습이 부족하다.**
   - 2026년 상반기 복기에서 중요했던 것은 `LEFT JOIN + 날짜 조건 + 근무 기록이 없는 행 + 0 집계`의 결합이다.
   - 저장소에는 각각의 요소를 사용한 문제는 있지만, 네 요소를 한 번에 다루는 대표 제출 코드가 없다.
2. **정답과 오답·대안이 한 파일에 같이 있다.**
   - 해설을 읽으면 이해되지만, 빈 화면 재현력을 판정하기 어렵다.
3. **MySQL과 Oracle 풀이가 섞여 있다.**
   - 실제 시험 방언 확인 전까지 MySQL 한 가지로 고정한다.
4. **`BETWEEN`보다 반열린 구간을 우선할 문제들이 있다.**
   - `DATE`만 있으면 종료일 포함 `BETWEEN`도 맞지만, 시간이 포함될 가능성까지 생각하면 `>= 시작 AND < 다음 시작`이 안전하다.
5. **`NOT IN`은 서브쿼리에 NULL이 들어오면 전체 판정이 UNKNOWN이 될 수 있다.**
   - 컬럼의 NOT NULL이 보장되지 않으면 `NOT EXISTS`를 우선한다.
6. **긴 해설의 “이해했다”와 쿼리 작성 능력을 분리해야 한다.**
   - 쿼리를 가리고 `FROM → WHERE → GROUP BY → HAVING → SELECT`의 데이터 변화를 직접 적어 본다.

### 4.3 P0 — 시험 전 반드시 빈 화면 재풀이할 SQL

| 문제 | 복습할 원리 | 반드시 만들 반례 |
|---|---|---|
| `없어진 기록 찾기` | LEFT JOIN anti-join, NULL | 오른쪽 행이 없는 개체 |
| `입양 시각 구하기(2)` | 전체 시간 생성, LEFT JOIN, 0건 표시 | 어떤 시각의 기록이 0건 |
| [대장균들의 자식의 수](<../../sql/platform/programmers/대장균들의_자식의_수_구하기.sql>) | 셀프 LEFT JOIN, `COUNT(C.ID)` | 자식이 없는 부모 |
| [대여 횟수가 많은 자동차들의 월별 대여 횟수](<../../sql/platform/programmers/대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기.sql>) | 전체 기간 대상 선정 후 월별 재집계 | 한 달은 5회 미만이지만 전체는 5회 이상 |
| [서울에 위치한 식당 목록](<../../sql/platform/programmers/서울에_위치한_식당_목록_출력하기.sql>) | JOIN 후 집계, 출력 grain | 리뷰 여러 건으로 식당 행 증가 |
| [상품을 구매한 회원 비율](<../../sql/platform/programmers/상품을 구매한 회원 비율 구하기.sql>) | 고정 분모, 월별 분자, `COUNT(DISTINCT)` | 같은 회원이 한 달에 여러 번 구매 |
| [온라인·오프라인 판매 통합](<../../sql/platform/programmers/온라인_판매_데이터_통합하기.sql>) | `UNION ALL`, 양쪽 컬럼 타입·순서, 선필터링 | 값이 같은 판매 행 두 건 |
| [특정 기간 대여 가능한 자동차](<../../sql/platform/programmers/특정 기간동안 대여 가능한 자동차들의 대여비용 구하기.sql>) | 기간 겹침, `NOT EXISTS`, 계산 후 필터 | 시작일·종료일이 경계와 같은 기록 |
| `자동차 대여 기록에서 대여중·대여 가능 여부 구분하기` | 조건부 집계, 특정 기준일 | 같은 차의 과거·현재 기록이 함께 존재 |
| `5월 식품들의 총매출 조회하기` | 1:N JOIN, `SUM`, 그룹 기준 | 상품 하나에 주문 여러 행 |

### 4.4 SQL에서 반드시 복습할 8개 원리

#### 1. 결과 한 행의 의미(grain)

쿼리를 쓰기 전에 다음 문장을 먼저 완성한다.

> 결과 한 행은 `_____` 하나를 의미한다.

예: “2022년의 한 달과 자동차 한 대의 조합”이라고 정했다면 `GROUP BY MONTH, CAR_ID`가 자연스럽게 나온다.

#### 2. JOIN 후 행 수

- 1:1 JOIN인지
- 1:N JOIN인지
- N:M으로 행이 곱해질 수 있는지
- JOIN 전에 한쪽을 먼저 집계해야 하는지

를 확인한다.

#### 3. `COUNT(*)`와 `COUNT(column)`

- `COUNT(*)`: LEFT JOIN으로 만들어진 NULL 확장 행도 센다.
- `COUNT(right.id)`: 오른쪽 실제 행이 있을 때만 센다.

0건을 0으로 보여 줄 때는 보통 `LEFT JOIN + COUNT(right.id)`가 필요하다.

#### 4. `ON`과 `WHERE`

왼쪽 행을 보존해야 하는데 오른쪽 테이블 조건을 `WHERE`에 두면 OUTER JOIN이 사실상 INNER JOIN처럼 바뀔 수 있다.

```sql
LEFT JOIN work w
  ON e.employee_id = w.employee_id
 AND w.office_date >= '2023-07-01'
 AND w.office_date <  '2023-08-01'
```

기간 기록이 없는 직원도 남겨야 한다면 날짜 조건을 `ON`에 둔다.

#### 5. NULL의 3값 논리

- `column = NULL`이 아니라 `IS NULL`
- `COUNT(column)`은 NULL 제외
- `SUM` 결과가 NULL이면 `COALESCE`
- `NOT IN` 목록에 NULL이 있을 가능성을 확인

#### 6. 날짜

- 한 달: `>= 'YYYY-MM-01' AND < '다음 달 01'`
- 대여 일수: `DATEDIFF(end, start) + 1`
- 두 기간 겹침: `A.start <= B.end AND A.end >= B.start`
- 날짜 출력 함수는 가능하면 `SELECT`에서만 사용

#### 7. 집계 전·후 필터

- 개별 행: `WHERE`
- 그룹 결과: `HAVING`
- 별칭의 `HAVING` 사용은 MySQL 편의 문법일 수 있음

#### 8. 중복

- 같은 회원의 여러 구매: `COUNT(DISTINCT user_id)`
- 단순 세로 결합: `UNION ALL`
- 정말 중복 제거가 요구될 때만 `UNION`
- GROUP BY로 최대값을 구했다고 그 행의 다른 컬럼이 자동으로 따라오지는 않음

### 4.5 MySQL 8 실전 문법과 표준 풀이

공식 문서:

- [JOIN 문법](https://dev.mysql.com/doc/refman/8.0/en/join.html)
- [GROUP BY 처리](https://dev.mysql.com/doc/refman/8.0/en/group-by-handling.html)
- [윈도우 함수](https://dev.mysql.com/doc/refman/8.0/en/window-function-descriptions.html)
- [CTE와 재귀 CTE](https://dev.mysql.com/doc/refman/8.0/en/with.html)

#### 먼저 기억할 논리 실행 순서

```text
FROM / JOIN
→ WHERE
→ GROUP BY
→ HAVING
→ SELECT
→ ORDER BY
→ LIMIT
```

작성할 때도 `SELECT`부터 꾸미지 말고 **기준 테이블과 필요한 행을 먼저 만든다**.

#### 1. 기본 조회·정렬·상위 N개

```sql
SELECT
    p.product_id,
    p.product_name,
    p.price
FROM product AS p
WHERE p.price >= 10000
ORDER BY p.price DESC, p.product_id ASC
LIMIT 5;
```

정렬 기준은 문제 문장 순서대로 모두 옮긴다. 동점 기준을 빼면 예제는 맞아도 채점에서 틀릴 수 있다.

#### 2. 그룹 집계와 HAVING

```sql
SELECT
    o.user_id,
    COUNT(*) AS order_count,
    SUM(o.amount) AS total_amount
FROM orders AS o
WHERE o.order_date >= '2026-07-01'
  AND o.order_date <  '2026-08-01'
GROUP BY o.user_id
HAVING COUNT(*) >= 2
ORDER BY total_amount DESC, o.user_id ASC;
```

- `WHERE`: 집계할 원본 행을 거른다.
- `HAVING`: 만들어진 그룹을 거른다.
- 다른 테이블과 JOIN하여 행이 늘어났다면 `COUNT(*)`가 정말 세려는 대상인지 다시 본다.

#### 3. INNER JOIN — 양쪽에 존재하는 행

```sql
SELECT
    p.product_id,
    p.product_name,
    SUM(o.quantity * p.price) AS sales
FROM product AS p
JOIN food_order AS o
  ON o.product_id = p.product_id
WHERE o.produce_date >= '2026-05-01'
  AND o.produce_date <  '2026-06-01'
GROUP BY p.product_id, p.product_name
ORDER BY sales DESC, p.product_id ASC;
```

`product 1행 : order 여러 행`이면 JOIN 후에는 주문 수만큼 상품 행이 늘어난다. 따라서 결과 grain에 맞춰 다시 묶는다.

#### 4. LEFT JOIN — 기록이 0건인 기준 행도 보존

```sql
SELECT
    e.employee_id,
    e.employee_name,
    COUNT(w.work_id) AS work_count
FROM employee AS e
LEFT JOIN work AS w
  ON w.employee_id = e.employee_id
 AND w.office_date >= '2026-07-01'
 AND w.office_date <  '2026-08-01'
GROUP BY e.employee_id, e.employee_name
ORDER BY e.employee_id;
```

오답이 되기 쉬운 형태:

```sql
-- 7월 기록이 없는 직원은 w.office_date가 NULL이므로 WHERE에서 사라진다.
LEFT JOIN work AS w
  ON w.employee_id = e.employee_id
WHERE w.office_date >= '2026-07-01'
  AND w.office_date <  '2026-08-01'
```

0건을 0으로 세려면 `COUNT(*)`가 아니라 `COUNT(w.work_id)`를 사용한다. MySQL 공식 문서도 LEFT JOIN 뒤 오른쪽 테이블 조건을 `WHERE`에 두면 생성된 NULL 행이 제거되어 INNER JOIN과 같은 결과가 될 수 있음을 설명한다.

#### 5. 조건부 집계 — 여러 행을 한 상태로 접기

```sql
SELECT
    h.car_id,
    CASE
        WHEN MAX(
            CASE
                WHEN '2026-07-19' BETWEEN h.start_date AND h.end_date
                THEN 1 ELSE 0
            END
        ) = 1
        THEN '대여중'
        ELSE '대여 가능'
    END AS availability
FROM car_rental_history AS h
GROUP BY h.car_id
ORDER BY h.car_id DESC;
```

차량 하나에 기록이 여러 개일 때 행별 `CASE`만 쓰면 상태가 여러 행 나온다. `MAX`로 “하나라도 현재 대여 중인가”를 차량 단위로 접는다.

#### 6. 중복 사용자를 한 번만 세기

```sql
SELECT
    YEAR(s.sales_date) AS sales_year,
    MONTH(s.sales_date) AS sales_month,
    COUNT(DISTINCT s.user_id) AS purchased_users
FROM online_sale AS s
GROUP BY YEAR(s.sales_date), MONTH(s.sales_date);
```

같은 회원이 같은 달에 여러 번 구매할 수 있으면 `COUNT(*)`가 아니라 `COUNT(DISTINCT user_id)`가 분자다.

#### 7. 날짜 범위와 기간 겹침

한 달 조회:

```sql
WHERE created_at >= '2026-07-01'
  AND created_at <  '2026-08-01'
```

두 기간이 겹치는 조건:

```sql
existing_start <= wanted_end
AND existing_end >= wanted_start
```

겹치지 않는 기록만 필요한 경우:

```sql
SELECT c.car_id
FROM car AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM rental AS r
    WHERE r.car_id = c.car_id
      AND r.start_date <= '2026-11-30'
      AND r.end_date >= '2026-11-01'
);
```

날짜 컬럼에 `DATE_FORMAT()`이나 `YEAR()`를 씌워 비교하면 인덱스 활용이 불리할 수 있다. 출력 포맷에는 함수를 써도, 필터는 가능하면 원본 컬럼의 범위 비교로 쓴다.

#### 8. 그룹별 최대 행

```sql
WITH ranked AS (
    SELECT
        r.*,
        RANK() OVER (
            PARTITION BY r.category
            ORDER BY r.score DESC
        ) AS ranking
    FROM restaurant AS r
)
SELECT category, restaurant_id, score
FROM ranked
WHERE ranking = 1
ORDER BY category;
```

- `ROW_NUMBER`: 동점이어도 1, 2, 3처럼 하나씩 번호
- `RANK`: 동점은 같은 등수, 다음 등수 건너뜀
- `DENSE_RANK`: 동점은 같은 등수, 다음 등수 연속

최댓값 동점 행을 모두 출력해야 하면 `RANK() = 1` 또는 최대값 서브쿼리와 JOIN을 쓴다.

#### 9. 존재하지 않는 행 찾기

LEFT anti-join:

```sql
SELECT a.id
FROM animal_outs AS a
LEFT JOIN animal_ins AS b
  ON b.animal_id = a.animal_id
WHERE b.animal_id IS NULL;
```

상관 `NOT EXISTS`:

```sql
SELECT a.id
FROM animal_outs AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM animal_ins AS b
    WHERE b.animal_id = a.animal_id
);
```

서브쿼리 결과에 NULL 가능성이 있으면 `NOT IN`보다 `NOT EXISTS`가 안전하다.

#### 10. UNION ALL과 CTE

```sql
WITH combined AS (
    SELECT sales_date, product_id, user_id, sales_amount
    FROM online_sale
    WHERE sales_date >= '2026-03-01'
      AND sales_date <  '2026-04-01'

    UNION ALL

    SELECT sales_date, product_id, NULL AS user_id, sales_amount
    FROM offline_sale
    WHERE sales_date >= '2026-03-01'
      AND sales_date <  '2026-04-01'
)
SELECT *
FROM combined
ORDER BY sales_date, product_id, user_id;
```

- 행을 그대로 이어 붙이면 `UNION ALL`
- 중복 제거가 문제 요구사항일 때만 `UNION`
- 양쪽 `SELECT`의 컬럼 수·순서·호환 타입을 맞춘다.
- CTE는 복잡한 대상을 “대상 선정 → 계산 → 출력” 단계로 분리할 때 사용한다.

재귀 CTE는 이번 시험의 P0가 아니지만, 구조만 기억한다.

```sql
WITH RECURSIVE tree AS (
    SELECT id, parent_id, 1 AS generation
    FROM ecoli_data
    WHERE parent_id IS NULL

    UNION ALL

    SELECT child.id, child.parent_id, tree.generation + 1
    FROM ecoli_data AS child
    JOIN tree
      ON child.parent_id = tree.id
)
SELECT *
FROM tree;
```

### 4.6 SQL 문제를 푸는 고정 절차

쿼리를 쓰기 전에 아래 여섯 줄을 메모한다.

```text
1. 결과 한 행: 무엇 하나인가?
2. 기준 테이블: 0건이어도 남아야 하는 대상은 무엇인가?
3. 필요한 원본 행: WHERE에서 무엇을 거를 것인가?
4. JOIN 관계: 1:1, 1:N, N:M 중 무엇이며 몇 행으로 늘어나는가?
5. 집계: COUNT의 대상 컬럼과 GROUP BY 키는 무엇인가?
6. 마지막 검증: NULL, 날짜 양끝, 중복, 동점, 정렬은 안전한가?
```

최소 반례는 다음 순서로 만든다.

| 반례 | 확인할 실수 |
|---|---|
| 기준 행은 있으나 오른쪽 기록 0건 | LEFT JOIN이 보존되는가, 0으로 세는가 |
| 오른쪽 기록 2건 | JOIN 후 중복·SUM·COUNT가 맞는가 |
| 날짜가 시작일·종료일과 정확히 같음 | 포함 경계가 맞는가 |
| 같은 회원이 같은 달에 2회 구매 | `DISTINCT`가 필요한가 |
| 최댓값 동점 2건 | 한 행만 또는 모두 출력하는 요구를 지켰는가 |
| NULL 1건 | `IS NULL`, `COALESCE`, `NOT EXISTS`가 필요한가 |

## 5. 7월 19~24일 실행 계획

### 5.1 시간 배분

코딩 실기 시간이 최대 2시간이고 AI역량검사는 최대 1시간 30분이다. 다만 현재 가장 큰 위험은 코테 손 감각이므로, 준비 시간은 다음처럼 배분한다.

| 하루 가용 시간 | Java·SQL | AI역량검사 | 기록·정리 |
|---:|---:|---:|---:|
| 표준 6시간 | 4시간 10분 | 1시간 20분 | 30분 |
| 최소 3시간 | 2시간 5분 | 40분 | 15분 |

최소안에서도 **템플릿 20분 → 제한시간 문제 80분 → SQL 25분 → AI 녹화 40분 → 오답 15분** 순서를 지킨다. 영상 시청만 하고 문제나 녹화를 생략하지 않는다.

### 5.2 날짜별 순서

#### 7월 19일 — 손 감각 복구와 기준점 측정

1. Java Collections·BFS·단조 스택 템플릿 백지 입력: 45분
2. `공원 산책`: 25분
3. `재구매가 일어난 상품과 회원 리스트 구하기`: 25분
4. `없어진 기록 찾기`: 30분
5. SQL 논리 실행 순서와 LEFT JOIN 0건 템플릿 백지 입력: 35분
6. 오답 분류와 AI 힌트·검증: 30분
7. AI역검 환경 확인과 핵심 8문항 키워드 카드: 50분

어떤 노트와 기존 코드도 보지 않고 시작한다. 각 문제에 `소요시간 / 문법·유형·구현·검증 중 막힌 원인 / 놓친 반례 / AI 사용 단계`를 기록한다.

판정:

- 세 문제 모두 제한시간 통과: 계획 유지
- 한 문제 실패: 7월 20일 첫 문제로 재풀이
- 두 문제 이상 실패: P1·P2를 중단하고 P0와 템플릿만 수행

#### 7월 20일 — 구현·Set/Map과 SQL NULL·날짜

Java:

1. 전날 오답 재풀이
2. `개인정보 수집 유효기간`
3. `달리기 경주`
4. `실패율`
5. `방문 길이`는 앞 문제가 통과했을 때만

SQL:

1. `조건에 맞는 회원수`
2. `자동차 대여 기록에서 대여중·대여 가능 여부 구분하기`
3. `대장균들의 자식의 수`

AI역검:

1. 6분 팩트체크 영상으로 오해 제거
2. 자기소개·지원동기·직무강점·약점 4문항을 각각 45~60초 녹화
3. AI에는 스크립트 재작성 대신 `결론까지 걸린 시간 / 반복어 / 한 답변의 사례 수 / 서류와 충돌`만 분석시킨다.

완료 기준:

- `HashSet.add/contains`, `HashMap.getOrDefault/computeIfAbsent`를 검색 없이 사용
- 날짜를 한 단위로 환산하거나 반열린 구간으로 처리
- `COUNT(*)`와 `COUNT(right.id)` 차이를 3행 데이터로 설명
- 네 답변 모두 첫 10초 안에 결론 제시

#### 7월 21일 — 그리디·정렬과 SQL JOIN

Java:

1. `구명보트`
2. `요격 시스템`
3. `큰 수 만들기`
4. `조이스틱`은 앞의 세 문제가 통과했을 때만

SQL:

1. `5월 식품들의 총매출 조회하기`
2. `카테고리별 도서 판매량 집계하기`
3. `없어진 기록 찾기` 재풀이

AI역검:

1. 실패·갈등·협업·문제해결 4문항을 각각 60~90초 녹화
2. 사례마다 `상황 1문장 → 내가 한 판단·행동 → 결과 → 한계·배운 점`만 유지
3. 전날 가장 약한 답변 1개를 다시 녹화

완료 기준:

- 그리디의 정렬 기준과 선택 이유를 코드 전 1분 안에 설명
- Comparator의 1·2·3차 기준을 코드와 일치시킴
- JOIN 전후 예상 행 수를 적고 쿼리 작성
- 과장된 수치·검증하지 않은 성과·모르는 Java/Spring 경험 추가 0건

#### 7월 22일 — 스택·BFS와 SQL 심화, 검사 공급사 분기

Java:

1. `괄호 회전하기`
2. `주식가격`
3. `게임 맵 최단거리`를 BFS로 재작성

SQL:

1. `대여 횟수가 많은 자동차들의 월별 대여 횟수`
2. `상품을 구매한 회원 비율`
3. `특정 기간 대여 가능한 자동차`

AI역검:

- 초대 메일에서 **JOBDA/마이다스 계열이 확인됨**: 공식 튜토리얼 1회와 전략게임 2종만 연습
- 다른 공급사가 확인됨: 해당 공급사 공식 튜토리얼만 사용
- 아직 확인되지 않음: 게임별 공략은 미루고 영상답변 4문항과 장비 점검만 수행

완료 기준:

- Java 세 문제 중 두 문제 이상 무해설 통과
- BFS 방문 처리를 큐 삽입 시점에 수행
- SQL 세 문제 모두 대상 집합과 출력 집계를 말로 분리
- 게임 연습·공략 영상 합계 45분을 넘기지 않음

#### 7월 23일 — 2시간 코딩 모의와 90분 AI 모의

기존 문서의 5문제 혼합 모의를 실제 시험과 같은 흐름으로 수행한다.

| 문제 | 시작 | 첫 제출 | 최종 결과 | 막힌 원인 | 다음 행동 |
|---|---:|---:|---|---|---|
| 1 |  |  |  |  |  |
| 2 |  |  |  |  |  |
| 3 |  |  |  |  |  |
| 4 |  |  |  |  |  |
| 5 |  |  |  |  |  |

코딩 모의 합격 기준:

- 10분 안에 전체 문제를 훑고 순서를 정함
- 확실한 문제 3개 이상 통과
- SQL JOIN·집계 문제 중 최소 2개 통과
- 한 문제에 35분 이상 고착되지 않음
- 마지막 15분을 최소·경계·중복·NULL 반례에 사용

AI 모의 합격 기준:

- 90분 흐름을 중단 없이 완료
- 답변 첫 문장에서 결론 제시
- 제출 서류와 다른 사실·과장 수치 0건
- 한 답변에 핵심 사례 하나만 사용
- 카메라·마이크·네트워크·알림 차단 문제 0건

모의 직후 AI에게 전체 정답을 맡기지 말고, 코딩 오답은 실패 반례부터, 영상은 전사문에서 반복어와 구조만 분석시킨다.

#### 7월 24일 — 오답 고정과 컨디션 회복

1. Java 모의 오답 1문제 백지 재풀이
2. SQL 모의 오답 2문제 백지 재풀이
3. `Map/Set/Deque/Comparator/BFS` 템플릿 중 막혔던 것만 20분 재입력
4. AI 취약 답변 2개만 재녹화
5. 검사 URL·브라우저·카메라·마이크·신분 확인 및 장소 점검

새 문제·새 알고리즘·새 영상·새 사례는 추가하지 않는다. 저녁에는 정답 코드를 읽는 대신 오답 카드만 보고 수면을 확보한다.

## 6. AI역량검사 자료 분석과 최소 준비량

### 6.1 먼저 확인된 사실

- [BNK시스템 2026년 신입 공개채용 공고](https://bnksys.recruiter.co.kr/app/jobnotice/view?jobnoticeSn=259197&systemKindCode=MRS2)는 AI역량검사 최대 1시간 30분, 실기시험 최대 2시간, 7월 25~26일 실시를 안내한다.
- 같은 공고에는 **AI역량검사 공급사나 세부 게임 유형이 적혀 있지 않다**. 따라서 JOBDA를 확정 형식으로 가정하면 안 된다.
- [JOBDA 역량검사 소개](https://www.jobda.im/acca/introduce)는 결과표에서 강점·약점과 면접 예상 질문을 제공하고 월 5회 응시 기회를 안내한다.
- [JOBDA 구 튜토리얼](https://www.jobda.im/acc/tutorial)에는 전략게임과 영상면접 연습 흐름이 있다. 다만 실제 BNK 초대 화면과 이름·구성이 같을 때만 세부 게임 연습에 사용한다.

### 6.2 자료와 YouTube 시청 순서

| 우선순위 | 자료 | 사용법 | 시간 |
|---|---|---|---:|
| 필수 | [BNK 채용 공고](https://bnksys.recruiter.co.kr/app/jobnotice/view?jobnoticeSn=259197&systemKindCode=MRS2) | 일정·검사시간·공지 확인 | 5분 |
| 필수 | BNK 초대 메일과 실제 튜토리얼 | 공급사·권장 브라우저·장비·세부 단계 확정 | 10분 |
| 필수 | [AI역량검사 FAQ 팩트체크, 마이다스 현직자 포함](https://www.youtube.com/watch?v=1cLSjDLdOjg) | 시선·게임 점수 등에 관한 과도한 속설을 걷어내는 용도. 과거 영상이므로 세부 화면 확인용으로는 쓰지 않음 | 6분 23초 |
| 조건부 | [JOBDA 역량검사 소개](https://www.jobda.im/acca/introduce) | JOBDA 계열이 확인됐을 때 결과표와 연습 흐름 파악 | 10분 |
| 조건부 | [JOBDA 공식 전략게임 재생목록](https://www.youtube.com/playlist?list=PLRvhT8gNnOeoZNbmGq7GjImm7CC7e7-XU) | 약한 게임 2개만 골라 설명 1회 → 바로 실습 | 최대 20분 |
| 선택 | [마이다스 검수 AI면접 개요](https://www.youtube.com/watch?v=6EB9lEr2kC0) | 처음 형식을 접할 때만 전체 구조 확인. 오래된 영상이므로 현재 초대 화면을 우선 | 29분 |
| 참고 | [서울시 AI면접체험 자료 안내](https://youth.seoul.go.kr/resource/file/AI_conts.pdf) | 공공 지원 프로그램과 JOBDA 채널 등 추가 자료 목록 확인 | 필요 부분만 |

긴 영상은 많이 볼수록 좋은 것이 아니다. 이 일정에서 **공통 개요 영상은 35분 이내**, 공급사 확인 후 **게임별 영상은 20분 이내**로 제한한다. 1시간이 넘는 과거 특강과 “게임 만점 공식”, “특정 표정·시선이면 합격” 같은 단정적 콘텐츠는 시험 전 우선순위에서 제외한다.

### 6.3 코딩과 병행 가능한 실제 준비량

AI역량검사는 총 **약 4시간 50분**이면 이번 주의 최소 준비를 끝낼 수 있다.

| 작업 | 횟수 × 시간 | 합계 |
|---|---:|---:|
| 형식·공급사·장비 확인 | 1 × 30분 | 30분 |
| 핵심 8문항 키워드 카드 | 1 × 40분 | 40분 |
| 4문항씩 녹화·피드백 | 2 × 45분 | 90분 |
| 공급사 공식 튜토리얼·약한 게임 | 1 × 40분 | 40분 |
| 90분 전체 모의 | 1 × 90분 | 90분 |
| **총합** |  | **4시간 50분** |

먼저 완성할 핵심 8문항:

1. 60초 자기소개
2. BNK시스템 지원동기
3. 직무에 연결되는 강점
4. 약점과 보완 행동
5. 실패 경험
6. 갈등·협업 경험
7. 어려운 문제를 해결한 경험
8. 개인 프로젝트 이후 Java·SQL 실무 준비 상태

시간이 남을 때만 입사 후 목표, 윤리·규정 준수, 반복업무, 압박 상황 등 나머지 질문을 추가한다. 문장을 외우지 말고 답변마다 `결론 / 사례 키워드 / 결과 / 한계` 네 칸만 적는다.

### 6.4 AI를 활용한 영상답변 검토

녹화 파일을 직접 보며 먼저 체크하고, 음성 전사문을 AI에 넣어 다음만 분석한다.

```text
이 답변의 사실관계를 새로 만들거나 표현을 화려하게 바꾸지 마.
① 첫 결론까지 걸린 문장 수
② STAR에서 빠진 요소
③ 반복어·군더더기
④ 한 답변에 섞인 사례 수
⑤ 60초 버전에서 지울 문장
⑥ 면접관이 물을 꼬리질문 3개
만 알려 줘.
```

평가 기준:

- **내용:** 질문에 답했는가, 사실인가, 판단 기준이 드러나는가
- **구조:** 결론이 먼저이고 사례 하나로 이어지는가
- **전달:** 너무 빠르지 않고 문장 끝이 흐려지지 않는가
- **환경:** 얼굴·음성이 선명하고 알림·소음·역광이 없는가

억지로 계속 웃거나 카메라를 한 점으로 노려보는 식의 연기는 하지 않는다. 자연스럽게 화면을 보고 또렷하게 답하며, 게임을 망쳤다고 느껴도 임의 종료하지 않고 안내에 따라 끝까지 수행한다.

## 7. 복습 방법

### 7.1 문제당 3회 규칙

1. **1회차:** 제한시간 안에 빈 화면 풀이
2. **2회차:** 틀렸다면 핵심 힌트만 보고 수정
3. **3회차:** 다음 날 다시 빈 화면 풀이

3회차까지 통과한 문제만 “복습 완료”로 표시한다.

### 7.2 문제당 3줄 카드

긴 풀이 문서 대신 다음 세 줄만 별도 메모한다.

```text
트리거: 어떤 표현을 보고 이 유형임을 알았는가?
원리: 왜 이 알고리즘/쿼리가 맞는가?
반례: 내가 가장 놓치기 쉬운 입력은 무엇인가?
```

예:

```text
트리거: 가중치 없는 격자의 최단거리
원리: BFS는 시작점에서 거리 순으로 방문하므로 최초 도착이 최단
반례: 시작=도착, 막힌 목적지, 방문 처리를 poll 때 해서 중복 삽입
```

### 7.3 해설을 봐도 되는 시점

- Lv1: 20~25분
- Lv2: 35~45분
- SQL 기본: 20분
- SQL JOIN·서브쿼리: 30~35분

시간이 끝나기 전에는 저장소 코드를 열지 않는다. 시간이 끝나면 전체 정답보다 **다음 한 단계의 힌트**만 본다.

## 8. 최종 체크포인트

### Java

- [ ] P0 중 최소 8문제를 다음 날 무해설로 다시 풀었다.
- [ ] `게임 맵 최단거리`를 BFS로 제출한다.
- [ ] `조이스틱`의 변수 오타 없이 컴파일된다.
- [ ] `ArrayDeque`, `HashMap`, `HashSet`, `Arrays.sort` 기본 문법을 빈 화면에서 쓴다.
- [ ] Comparator의 동점 기준을 누락하지 않는다.
- [ ] 합계·상한에 따라 `long`을 선택한다.
- [ ] 제출 전 최소 입력, 길이 1, 중복, 경계를 직접 확인한다.

### SQL

- [ ] `LEFT JOIN` 오른쪽 조건을 `ON`과 `WHERE` 중 어디에 둘지 설명한다.
- [ ] `COUNT(*)`와 `COUNT(column)`의 NULL 차이를 설명한다.
- [ ] 결과 한 행의 grain을 먼저 적는다.
- [ ] JOIN 전후 행 수 증가를 예상한다.
- [ ] 월 범위를 반열린 구간으로 쓴다.
- [ ] `COUNT(DISTINCT)` 필요 여부를 확인한다.
- [ ] `NOT IN`의 NULL 위험을 확인한다.
- [ ] `UNION ALL`과 `UNION`을 구분한다.
- [ ] 정렬 1·2·3순위를 모두 반영한다.

### AI역량검사

- [ ] 핵심 8문항의 45~60초 답변을 녹화했다.
- [ ] 주요 경험형 질문의 90초 답변을 녹화했다.
- [ ] 답변별 사실·판단 기준·결과·한계를 구분했다.
- [ ] 과장 금지 목록을 다시 확인했다.
- [ ] 실제 검사 업체 확인 전 특정 게임 유형에 과도하게 투자하지 않았다.
- [ ] 90분 전체 모의를 한 번 수행했다.

## 9. 최종 판단

현재 준비량은 부족하지 않다. Java 고급 유형과 SQL Lv4~5까지 이미 경험했기 때문에 **새 문제를 많이 추가하는 것은 합격률을 크게 높이지 않는다**.

남은 핵심 위험은 세 가지다.

1. 저장된 Java 코드와 실제 제출 가능한 코드 사이의 차이
2. SQL 해설 이해와 NULL·JOIN 반례의 백지 재현 사이의 차이
3. AI 답변 계획과 실제 카메라 앞 수행 사이의 차이

따라서 시험 전 목표는 “몇 문제를 더 봤는가”가 아니라 다음으로 고정한다.

> Java P0를 제한시간 내 재현하고, SQL에서 LEFT JOIN·NULL·날짜 경계를 반례로 검증하며, 2시간 코딩 모의와 90분 AI 모의를 각각 한 번 완주한다.
