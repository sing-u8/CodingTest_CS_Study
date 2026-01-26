-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/301649
-- 대장균의 크기에 따라 분류하기 2
-- 레벨3

--- MYSQL

SELECT
    ID,
    CASE
        WHEN QUARTILE = 1 THEN 'CRITICAL'
        WHEN QUARTILE = 2 THEN 'HIGH'
        WHEN QUARTILE = 3 THEN 'MEDIUM'
        WHEN QUARTILE = 4 THEN 'LOW'
    END AS COLONY_NAME
FROM (
         SELECT
             ID,
             NTILE(4) OVER (ORDER BY SIZE_OF_COLONY DESC) AS QUARTILE
         FROM ECOLI_DATA
     ) A
ORDER BY ID ASC;

---

SELECT
    ID,
    CASE
        WHEN PER <= 0.25 THEN 'CRITICAL'
        WHEN PER <= 0.50 THEN 'HIGH'
        WHEN PER <= 0.75 THEN 'MEDIUM'
        ELSE 'LOW'
        END AS COLONY_NAME
FROM (
         SELECT
             ID,
             PERCENT_RANK() OVER (ORDER BY SIZE_OF_COLONY DESC) AS PER
         FROM ECOLI_DATA
     ) A
ORDER BY ID ASC;



/*

 이 문제는 전체 데이터를 **크기 순으로 줄 세운 뒤, 정확히 4등분**을 해야 하는 문제입니다.

이럴 때 가장 강력하고 편한 함수가 바로 윈도우 함수인 **`NTILE`**입니다.
SQL에서 순위나 등급을 매길 때 사용하는 함수들을 알면 아주 쉽게 풀 수 있습니다.

---

### 1. 핵심 해결 도구: `NTILE(n)`

* **기능:** 조회된 데이터를 **n개의 그룹**으로 균등하게 나눕니다.
* **사용법:** `NTILE(4) OVER (ORDER BY 컬럼 DESC)`
* 데이터를 4개의 그룹(1, 2, 3, 4)으로 나누는데,
* 컬럼 값이 큰 순서대로 1번 그룹부터 배정합니다.



---

### 2. 모범 답안 (SQL Solution)

서브쿼리를 이용해 먼저 등급(1~4)을 매기고, 바깥에서 이름을 붙여주는 방식이 가장 깔끔합니다.

```sql
SELECT
    ID,
    CASE
        WHEN QUARTILE = 1 THEN 'CRITICAL'
        WHEN QUARTILE = 2 THEN 'HIGH'
        WHEN QUARTILE = 3 THEN 'MEDIUM'
        WHEN QUARTILE = 4 THEN 'LOW'
    END AS COLONY_NAME
FROM (
    SELECT
        ID,
        NTILE(4) OVER (ORDER BY SIZE_OF_COLONY DESC) AS QUARTILE
    FROM ECOLI_DATA
) A
ORDER BY ID ASC;

```

---

### 3. 상세 풀이 (Step-by-Step)

#### ① `NTILE(4) OVER (ORDER BY SIZE_OF_COLONY DESC)`

* 전체 데이터를 `SIZE_OF_COLONY`가 큰 순서대로 정렬합니다. (`DESC`)
* 데이터를 4개의 바구니에 똑같이 나누어 담습니다.
* 상위 25% (가장 큰 녀석들) → **1번** 그룹
* 그 다음 25% → **2번** 그룹
* 그 다음 25% → **3번** 그룹
* 하위 25% (가장 작은 녀석들) → **4번** 그룹


* 문제에서 "총 데이터 수는 4의 배수"라고 했으므로, 정확히 N/4 개씩 나뉩니다.

#### ② `CASE WHEN ... END`

* 서브쿼리에서 구한 `QUARTILE` 번호(1, 2, 3, 4)를 문제에서 요구한 문자열('CRITICAL', 'HIGH'...)로 바꿔줍니다.

#### ③ `ORDER BY ID ASC`

* 마지막 결과는 문제 요구사항대로 `ID` 순으로 오름차순 정렬하여 출력합니다.

---

### 💡 튜터의 추가 팁 (다른 방법: `PERCENT_RANK`)

만약 `NTILE` 함수가 기억나지 않는다면 **`PERCENT_RANK()`** 함수를 쓸 수도 있습니다. 이 함수는 백분율 순위(0 ~ 1 사이 실수)를 반환합니다.

```sql
SELECT ID,
    CASE
        WHEN PER <= 0.25 THEN 'CRITICAL'
        WHEN PER <= 0.50 THEN 'HIGH'
        WHEN PER <= 0.75 THEN 'MEDIUM'
        ELSE 'LOW'
    END AS COLONY_NAME
FROM (
    SELECT ID,
           PERCENT_RANK() OVER (ORDER BY SIZE_OF_COLONY DESC) AS PER
    FROM ECOLI_DATA
) A
ORDER BY ID ASC;

```

* `NTILE`은 그룹 번호(정수)를 주고, `PERCENT_RANK`는 퍼센트(실수)를 줍니다.
* "4등분 하라"는 문제에서는 **`NTILE(4)`**가 훨씬 직관적이고 쓰기 편하므로 첫 번째 방법을 추천합니다!

 */