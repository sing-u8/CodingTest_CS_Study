-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131537
-- 오프라인/온라인_판매_데이터_통합하기
-- 레벨4

--- MySQL
SELECT *
FROM (
         SELECT
             DATE_FORMAT(ONS.SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
             ONS.PRODUCT_ID,
             ONS.USER_ID,
             ONS.SALES_AMOUNT
         FROM ONLINE_SALE ONS
         UNION
         SELECT
             DATE_FORMAT(OFS.SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
             OFS.PRODUCT_ID,
             NULL AS USER_ID,
             OFS.SALES_AMOUNT
         FROM OFFLINE_SALE OFS
     ) AS A
WHERE A.SALES_DATE >= '2022-03-01'
  AND A.SALES_DATE < '2022-04-01'
ORDER BY A.SALES_DATE ASC, A.PRODUCT_ID ASC, A.USER_ID ASC;

---

(SELECT
     DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
     PRODUCT_ID,
     USER_ID,
     SALES_AMOUNT
 FROM ONLINE_SALE
 WHERE SALES_DATE >= '2022-03-01' AND SALES_DATE < '2022-04-01')

UNION ALL

(SELECT
     DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
     PRODUCT_ID,
     NULL AS USER_ID,
     SALES_AMOUNT
 FROM OFFLINE_SALE
 WHERE SALES_DATE >= '2022-03-01' AND SALES_DATE < '2022-04-01')

ORDER BY SALES_DATE ASC, PRODUCT_ID ASC, USER_ID ASC;


/*

 작성하신 쿼리도 결과는 정확하게 나오지만, **성능(Performance)** 관점에서는 개선할 여지가 매우 큽니다.

현재 작성하신 방식은 **"일단 모든 데이터를 합치고(UNION), 나중에 3월 데이터만 필터링(WHERE)"**하는 방식입니다. 데이터가 수백만 건이라면 불필요한 데이터를 모두 메모리에 올렸다가 버리는 작업이 발생합니다.

더 효율적인 **모범 답안**과 그 이유를 3가지 포인트로 설명해 드릴게요.

### 1. 더 효율적인 모범 답안 (Recommended Solution)

**핵심 전략:** 각 테이블에서 **먼저 3월 데이터만 뽑아낸 뒤**, 그 결과물만 합치는 방식입니다.

```sql
(SELECT
    DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
    PRODUCT_ID,
    USER_ID,
    SALES_AMOUNT
FROM ONLINE_SALE
WHERE SALES_DATE >= '2022-03-01' AND SALES_DATE < '2022-04-01')

UNION ALL

(SELECT
    DATE_FORMAT(SALES_DATE, '%Y-%m-%d') AS SALES_DATE,
    PRODUCT_ID,
    NULL AS USER_ID,
    SALES_AMOUNT
FROM OFFLINE_SALE
WHERE SALES_DATE >= '2022-03-01' AND SALES_DATE < '2022-04-01')

ORDER BY SALES_DATE ASC, PRODUCT_ID ASC, USER_ID ASC;

```

---

### 2. 왜 이 방식이 더 좋을까요? (튜닝 포인트)

#### ① 조건절의 위치 (Filtering Location)

* **작성하신 쿼리:** 온라인/오프라인의 **전체 데이터(1월~12월)**를 먼저 합칩니다. 데이터 양이 방대해지고 메모리 사용량이 큽니다.
* **모범 답안:** 각 테이블에서 **3월 데이터만** 먼저 추려냅니다. 합쳐야 할 데이터 양이 획기적으로 줄어듭니다.

#### ② `UNION` vs `UNION ALL`

* **`UNION` (작성하신 방식):** 두 결과를 합칠 때 **중복된 행이 있는지 검사하고 제거(Sorting/Hashing)**하는 무거운 작업이 들어갑니다.
* **`UNION ALL` (추천 방식):** 중복 검사 없이 단순히 데이터를 아래에 붙여넣습니다.
* 온라인 테이블에는 `USER_ID`가 있고, 오프라인 테이블은 `NULL`이므로 두 데이터가 **완벽히 똑같을 확률은 0%**입니다. 따라서 속도가 훨씬 빠른 `UNION ALL`을 쓰는 것이 정답입니다.



#### ③ 인덱스 활용 (SARGable)

* **작성하신 쿼리:** `WHERE A.SALES_DATE >= ...`을 썼지만, 서브쿼리 내부에서 이미 `DATE_FORMAT`으로 날짜를 문자열로 변환해버렸다면 인덱스를 제대로 타지 못할 수 있습니다.
* **모범 답안:** `WHERE` 절에서 원본 `SALES_DATE` 컬럼을 그대로 사용하여 범위를 검색하므로 **인덱스(Index)**를 타고 아주 빠르게 데이터를 가져옵니다.

### 요약

1. **필터링 먼저 하기:** `WHERE` 조건을 각 `SELECT` 문 안으로 넣으세요.
2. **`UNION ALL` 사용:** 중복될 가능성이 없다면 `UNION ALL`이 훨씬 빠릅니다.
3. **인덱스 고려:** 날짜 변환(`DATE_FORMAT`)은 `WHERE` 절이 아닌 `SELECT` 절(보여주는 용도)에서만 하세요.

 */