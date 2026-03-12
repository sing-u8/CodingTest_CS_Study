-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131534
-- 상품을 구매한 회원 비율 구하기
-- 레벨5

--- MYSQL
-- 1. 2021년 가입자 총원(분모)을 미리 구해둡니다.
WITH TOTAL_2021_USERS AS (
    SELECT COUNT(*) AS TOTAL_CNT
    FROM USER_INFO
    WHERE YEAR(JOINED) = 2021
    )

SELECT
    YEAR(O.SALES_DATE) AS YEAR,
    MONTH(O.SALES_DATE) AS MONTH,
    COUNT(DISTINCT O.USER_ID) AS PURCHASED_USERS,
    -- 미리 구해둔 TOTAL_CNT를 Cross Join 방식(서브쿼리)으로 가져와 나눕니다.
    ROUND(COUNT(DISTINCT O.USER_ID) / (SELECT TOTAL_CNT FROM TOTAL_2021_USERS), 1) AS PUCHASED_RATIO
FROM ONLINE_SALE O
    JOIN USER_INFO U
ON O.USER_ID = U.USER_ID
WHERE YEAR(U.JOINED) = 2021
GROUP BY YEAR(O.SALES_DATE), MONTH(O.SALES_DATE)
ORDER BY YEAR ASC, MONTH ASC;



/*

 이 문제는 프로그래머스 SQL 고득점 Kit에서 가장 난이도가 높은(Level 5) 문제 중 하나로 꼽히는 **'상품을 구매한 회원 비율 구하기'** 입니다!

이 문제의 핵심은 **'분모(전체 회원 수)'는 고정되어 있는데, '분자(월별 구매 회원 수)'는 그룹화되어 계속 변한다**는 점을 어떻게 쿼리로 구현할 것인가에 있습니다. 또한, 앞서 우리가 다루었던 **`COUNT(DISTINCT)`** 개념이 여기서도 아주 중요하게 쓰입니다.

논리를 3단계로 쪼개서 가장 완벽하고 가독성 높은 쿼리를 작성해 보겠습니다.

---

### 💡 문제 해결의 3단계 핵심 논리

1. **고정된 분모 구하기 (2021년 가입자 수):**
비율을 계산하려면 먼저 '2021년에 가입한 전체 회원 수'를 구해야 합니다. 이 값은 월이 바뀌어도 변하지 않는 고정값입니다.
2. **대상자 필터링 및 조인 (`JOIN` & `WHERE`):**
온라인 판매 기록(`ONLINE_SALE`) 중에서, **2021년에 가입한 회원들의 구매 기록만** 남기도록 `USER_INFO` 테이블과 조인하고 필터링합니다.
3. **월별 분자 구하기 및 그룹화 (`GROUP BY` & `COUNT DISTINCT`):**
필터링된 기록을 년, 월별로 묶은 뒤, 중복 구매를 제외한 **순수 구매 회원 수**를 구하고, 이를 1번에서 구한 분모로 나누어 비율을 계산합니다.

---

### 🚀 최적 솔루션 1: 직관적인 서브쿼리(Subquery) 활용 (가장 추천)

가장 많이 쓰이고 깔끔한 형태의 풀이입니다. `SELECT` 절 안에 분모를 구하는 서브쿼리를 직접 집어넣는 방식입니다.

```sql
SELECT
    YEAR(O.SALES_DATE) AS YEAR,
    MONTH(O.SALES_DATE) AS MONTH,

    -- 분자: 해당 년/월에 구매한 '고유' 회원 수 (중복 제거 필수!)
    COUNT(DISTINCT O.USER_ID) AS PURCHASED_USERS,

    -- 비율 계산: (분자 / 분모) 후 소수점 두 번째 자리에서 반올림(ROUND 1)
    ROUND(
        COUNT(DISTINCT O.USER_ID) / (SELECT COUNT(*) FROM USER_INFO WHERE YEAR(JOINED) = 2021),
        1
    ) AS PUCHASED_RATIO

FROM ONLINE_SALE O
JOIN USER_INFO U
  ON O.USER_ID = U.USER_ID
WHERE YEAR(U.JOINED) = 2021 -- 2021년에 가입한 회원의 판매 기록만 필터링
GROUP BY
    YEAR(O.SALES_DATE),
    MONTH(O.SALES_DATE)
ORDER BY
    YEAR ASC,
    MONTH ASC;

```

---

### 🚀 최적 솔루션 2: WITH 절 (CTE) 활용 (가독성 극대화)

만약 "서브쿼리가 `SELECT` 절에 들어가는 게 보기 불편하다"고 느끼신다면, 앞서 즐겨 사용하셨던 `WITH` 절로 분모를 미리 계산해두고 가져다 쓰는 방식도 아주 훌륭합니다.

```sql
-- 1. 2021년 가입자 총원(분모)을 미리 구해둡니다.
WITH TOTAL_2021_USERS AS (
    SELECT COUNT(*) AS TOTAL_CNT
    FROM USER_INFO
    WHERE YEAR(JOINED) = 2021
)

SELECT
    YEAR(O.SALES_DATE) AS YEAR,
    MONTH(O.SALES_DATE) AS MONTH,
    COUNT(DISTINCT O.USER_ID) AS PURCHASED_USERS,
    -- 미리 구해둔 TOTAL_CNT를 Cross Join 방식(서브쿼리)으로 가져와 나눕니다.
    ROUND(COUNT(DISTINCT O.USER_ID) / (SELECT TOTAL_CNT FROM TOTAL_2021_USERS), 1) AS PUCHASED_RATIO
FROM ONLINE_SALE O
JOIN USER_INFO U
  ON O.USER_ID = U.USER_ID
WHERE YEAR(U.JOINED) = 2021
GROUP BY YEAR(O.SALES_DATE), MONTH(O.SALES_DATE)
ORDER BY YEAR ASC, MONTH ASC;

```

---

### 🚨 코딩 테스트 마스터의 핵심 체크포인트 (오답 노트)

이 문제에서 응시자들의 90%가 틀리는 3가지 함정입니다.

1. **`COUNT(DISTINCT USER_ID)` (가장 중요!)**
한 명의 회원이 2022년 1월에 옷을 3번 샀다고 가정해 봅시다. `ONLINE_SALE` 테이블에는 1월 기록이 3줄 남겠지만, **"상품을 구매한 회원 수"는 1명**으로 카운트해야 합니다. 따라서 그냥 `COUNT(USER_ID)`를 쓰면 비율이 1.0을 넘어가는 기현상이 발생하므로 반드시 `DISTINCT`를 붙여야 합니다.
2. **소수점 반올림 기준 (`ROUND`)**
문제에서 **"소수점 두 번째 자리에서 반올림"**하라고 했습니다. 이는 즉, **"소수점 첫째 자리까지 표시하라"**는 의미입니다. 따라서 `ROUND(값, 1)`을 사용해야 합니다.
*(예: 0.55 $\rightarrow$ 0.6)*
3. **스펠링 주의 (출제자 오타 😅)**
출력 예시를 자세히 보시면 `PURCHASED_RATIO`가 아니라 `PUCHASED_RATIO`(R이 빠짐)로 되어 있습니다. 프로그래머스 채점 서버는 이 사소한 오타 하나 때문에 오답 처리를 하는 경우가 잦으니, 요구하는 컬럼명을 복사해서 붙여넣기 하는 습관이 좋습니다!

---

단일 쿼리 안에서 고정된 전체 수(Denominator)와 변하는 그룹 수(Numerator)를 동시에 다루는 아주 수준 높은 문제였습니다. `(SELECT COUNT(*) FROM ...)` 형태의 스칼라 서브쿼리(Scalar Subquery)가 `SELECT` 절에서 어떻게 작동하는지 완전히 이해가 되셨나요?

 */