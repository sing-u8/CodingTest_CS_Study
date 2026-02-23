-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/299310
-- 연도별 대장균 크기의 편차 구하기
-- 레벨2



SELECT
    YEAR(DIFFERENTIATION_DATE) AS YEAR,
    (MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE)) - SIZE_OF_COLONY) AS YEAR_DEV,
    ID
FROM ECOLI_DATA
ORDER BY YEAR ASC, YEAR_DEV ASC;

---


SELECT
    YEAR(A.DIFFERENTIATION_DATE) AS YEAR,
    (B.MAX_SIZE - A.SIZE_OF_COLONY) AS YEAR_DEV,
    A.ID
FROM ECOLI_DATA A
    INNER JOIN (
    -- [Step 1] 연도별 가장 큰 크기를 구하는 테이블 만들기
    SELECT
    YEAR(DIFFERENTIATION_DATE) AS YEAR,
    MAX(SIZE_OF_COLONY) AS MAX_SIZE
    FROM ECOLI_DATA
    GROUP BY YEAR(DIFFERENTIATION_DATE)
    ) B
ON YEAR(A.DIFFERENTIATION_DATE) = B.YEAR
ORDER BY YEAR ASC, YEAR_DEV ASC;


/*

 이 문제는 **"그룹별 최댓값"을 구하고, 그 값을 다시 "각 행의 값"과 연산**해야 하는 문제입니다.

이런 유형의 문제는 **윈도우 함수(Window Function)**를 사용하면 아주 간단하게 풀 수 있고, 윈도우 함수가 익숙하지 않다면 **서브쿼리와 조인(Join)**을 사용해서 풀 수도 있습니다.

두 가지 방법을 모두 알려드릴게요.

---

### 1. 모범 답안 (윈도우 함수 사용 - 추천 ⭐)

`OVER (PARTITION BY ...)` 구문을 사용하면 그룹핑(GROUP BY)을 따로 하지 않고도, 각 행 옆에 "해당 연도의 최댓값"을 바로 붙일 수 있습니다. 코드가 매우 간결해집니다.

```sql
SELECT
    YEAR(DIFFERENTIATION_DATE) AS YEAR,
    (MAX(SIZE_OF_COLONY) OVER (PARTITION BY YEAR(DIFFERENTIATION_DATE)) - SIZE_OF_COLONY) AS YEAR_DEV,
    ID
FROM ECOLI_DATA
ORDER BY YEAR ASC, YEAR_DEV ASC;

```

#### 💡 상세 설명

1. **`YEAR(DIFFERENTIATION_DATE)`**: 날짜에서 연도만 추출합니다.
2. **`MAX(SIZE_OF_COLONY) OVER (PARTITION BY 연도)`**:
* 전체 데이터를 '연도'별로 칸막이(Partition)를 칩니다.
* 각 칸막이 안에서 가장 큰 대장균 크기(`MAX`)를 구합니다.
* 이 값은 합쳐지는 것이 아니라, 원래 데이터의 각 행 옆에 가상의 컬럼처럼 붙습니다.


3. **`- SIZE_OF_COLONY`**: 방금 구한 '해당 연도 최댓값'에서 '내 크기'를 뺍니다. 이것이 문제에서 요구한 편차(`YEAR_DEV`)입니다.

---

### 2. 다른 풀이 (서브쿼리 + JOIN 사용)

윈도우 함수를 지원하지 않는 옛날 버전의 DB이거나, 논리적인 흐름을 명확히 하고 싶다면 이 방식을 사용합니다.

1. **서브쿼리:** 연도별 최댓값을 먼저 구합니다.
2. **JOIN:** 원본 테이블과 서브쿼리를 '연도' 기준으로 연결합니다.

```sql
SELECT
    YEAR(A.DIFFERENTIATION_DATE) AS YEAR,
    (B.MAX_SIZE - A.SIZE_OF_COLONY) AS YEAR_DEV,
    A.ID
FROM ECOLI_DATA A
INNER JOIN (
    -- [Step 1] 연도별 가장 큰 크기를 구하는 테이블 만들기
    SELECT
        YEAR(DIFFERENTIATION_DATE) AS YEAR,
        MAX(SIZE_OF_COLONY) AS MAX_SIZE
    FROM ECOLI_DATA
    GROUP BY YEAR(DIFFERENTIATION_DATE)
) B
ON YEAR(A.DIFFERENTIATION_DATE) = B.YEAR
ORDER BY YEAR ASC, YEAR_DEV ASC;

```

#### 💡 상세 설명

1. **서브쿼리(B):** `GROUP BY`를 이용해 2019년의 최댓값, 2020년의 최댓값... 을 미리 구해둡니다.
2. **JOIN:** 원본 테이블(`A`)의 각 행에 해당하는 연도의 최댓값(`B.MAX_SIZE`)을 옆에 붙여줍니다.
3. **계산:** `B.MAX_SIZE`(최댓값) - `A.SIZE_OF_COLONY`(내 크기)를 계산합니다.

### 요약

실무나 코딩 테스트에서는 **1번(윈도우 함수)** 방법이 코드가 훨씬 짧고 성능도 우수하여 더 선호됩니다. 윈도우 함수 사용이 가능하다면 꼭 1번 방법을 익혀두세요!

 */