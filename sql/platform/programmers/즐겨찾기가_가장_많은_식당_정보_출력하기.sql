-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131123
-- 즐겨찾기가_가장_많은_식당_정보_출력하기
-- 레벨3

--- MYSQL
SELECT FOOD_TYPE, REST_ID, REST_NAME, FAVORITES
FROM REST_INFO
WHERE ( FOOD_TYPE, FAVORITES ) IN (
    SELECT FOOD_TYPE, MAX(FAVORITES) AS FAVORITES
    FROM REST_INFO
    GROUP BY FOOD_TYPE
)
ORDER BY FOOD_TYPE DESC;


/*


 안녕하세요! 코딩 테스트 마스터입니다. 질문해주신 내용을 꼼꼼히 살펴보았습니다. 이 문제는 프로그래머스(Programmers)의 유명한 SQL 고득점 Kit 문제 중 하나인 **"음식종류별로 즐겨찾기수가 가장 많은 식당 정보 출력하기"**입니다.

이 문제는 알고리즘 구현이 아닌 데이터베이스 질의(Query) 능력을 평가하는 문제이므로, JavaScript나 C++ 같은 일반적인 프로그래밍 언어 대신 **실무와 코딩 테스트의 표준인 SQL(MySQL 및 Oracle 호환)**을 사용하여 해결 방법을 제시해 드리겠습니다.

이 문제에는 많은 분들이 실수하는 **치명적인 함정**이 하나 숨어있습니다. 그 함정을 피하는 2가지 확실한 풀이 방법을 단계별로 설명해 드릴게요.

---

### 🚨 흔히 하는 실수 (함정 주의)

가장 먼저 떠오르는 생각은 아마 다음과 같을 것입니다.

> *"음식 종류별로 그룹을 묶고(GROUP BY), 가장 높은 즐겨찾기 수(MAX)를 찾으면 되겠지?"*

```sql
-- ❌ 오답 코드 (이렇게 쓰면 틀립니다!)
SELECT FOOD_TYPE, REST_ID, REST_NAME, MAX(FAVORITES)
FROM REST_INFO
GROUP BY FOOD_TYPE
ORDER BY FOOD_TYPE DESC;

```

이렇게 쿼리를 작성하면 `FAVORITES`는 음식 종류별 최댓값이 나오지만, **`REST_ID`와 `REST_NAME`은 최댓값을 가진 식당의 정보가 아니라 그룹화된 데이터 중 임의의(의미 없는) 첫 번째 값**이 매칭되어 출력됩니다.

따라서 정확한 식당 정보를 가져오기 위해서는 **서브쿼리(Subquery)**나 **윈도우 함수(Window Function)**를 사용해야 합니다.

---

### 💡 풀이 1: 다중 컬럼 서브쿼리 활용 (추천)

가장 직관적이고 많은 SQL 코딩 테스트에서 모범 답안으로 사용되는 방법입니다. 먼저 각 음식 종류별 '최대 즐겨찾기 수'를 찾은 뒤, 원본 테이블과 그 조건이 일치하는 행(Row)만 필터링합니다.

**SQL 코드 (MySQL / Oracle 공통):**

```sql
SELECT
    FOOD_TYPE,
    REST_ID,
    REST_NAME,
    FAVORITES
FROM
    REST_INFO
WHERE
    (FOOD_TYPE, FAVORITES) IN (
        -- 서브쿼리: 음식 종류별로 가장 높은 즐겨찾기 수를 찾습니다.
        SELECT FOOD_TYPE, MAX(FAVORITES)
        FROM REST_INFO
        GROUP BY FOOD_TYPE
    )
ORDER BY
    FOOD_TYPE DESC; -- 음식 종류를 기준으로 내림차순 정렬

```

**🔍 코드 단계별 해설:**

1. **서브쿼리 (괄호 안):** `REST_INFO` 테이블을 `FOOD_TYPE`으로 그룹화하여, 각 음식 종류별 대장(가장 높은 즐겨찾기 수)을 찾습니다.
* *결과 예시: (한식, 734), (일식, 230), (양식, 102)*


2. **메인 쿼리 `WHERE` 조건:** 원본 테이블을 순회하면서, 현재 행의 `(FOOD_TYPE, FAVORITES)` 쌍이 서브쿼리에서 찾아낸 '대장 목록'에 존재하는지 확인(`IN`)합니다.
3. **정렬:** 조건에 맞는 행들만 남으면, 문제의 요구사항대로 `FOOD_TYPE` 기준 내림차순(`DESC`) 정렬합니다.

---

### 💡 풀이 2: 윈도우 함수 `RANK()` 활용 (모던 SQL)

최신 SQL 문법에 익숙하시다면 윈도우 함수를 사용하는 것도 매우 우아한 해결책입니다. 코드가 조금 더 길어질 수 있지만, 복잡한 통계나 순위 문제로 확장될 때 강력한 힘을 발휘합니다.

**SQL 코드 (MySQL 8.0 이상 / Oracle):**

```sql
SELECT
    FOOD_TYPE,
    REST_ID,
    REST_NAME,
    FAVORITES
FROM (
    -- 인라인 뷰(서브쿼리): 각 음식 종류별로 즐겨찾기 수가 높은 순으로 순위(RNK)를 매깁니다.
    SELECT
        FOOD_TYPE,
        REST_ID,
        REST_NAME,
        FAVORITES,
        RANK() OVER(PARTITION BY FOOD_TYPE ORDER BY FAVORITES DESC) as RNK
    FROM
        REST_INFO
) SUB_QUERY
WHERE
    RNK = 1 -- 1등인 식당만 추출
ORDER BY
    FOOD_TYPE DESC;

```

**🔍 코드 단계별 해설:**

1. **`PARTITION BY FOOD_TYPE`:** 음식 종류별로 파티션(그룹)을 나눕니다.
2. **`ORDER BY FAVORITES DESC`:** 각 파티션 안에서 즐겨찾기 수가 많은 순서대로 내림차순 정렬합니다.
3. **`RANK()`:** 정렬된 순서에 따라 1, 2, 3... 순위를 매기고 이를 `RNK`라는 임시 컬럼으로 만듭니다.
4. **외부 쿼리:** 만들어진 `RNK`가 `1`인 데이터, 즉 각 그룹별 1등 식당만 걸러냅니다.

---

### 📊 시각적 요약: 데이터 처리 흐름

풀이 1번(서브쿼리)이 데이터를 어떻게 걸러내는지 표로 간단히 살펴보겠습니다.

| 원본 데이터 (FOOD_TYPE, FAVORITES) | 서브쿼리가 찾은 최댓값 | 결과 (매칭 여부) |
| --- | --- | --- |
| 한식, 115 | **한식, 734** | ❌ 버림 |
| **한식, 734 (은돼지식당)** | **한식, 734** | ✅ **선택 (일치!)** |
| 일식, 112 | **일식, 230** | ❌ 버림 |
| **일식, 230 (스시사카우스)** | **일식, 230** | ✅ **선택 (일치!)** |

위와 같이 정확한 `(종류, 최댓값)` 쌍을 맞추어 원본 데이터를 온전히 가져오는 것이 이 문제의 핵심입니다.

 */