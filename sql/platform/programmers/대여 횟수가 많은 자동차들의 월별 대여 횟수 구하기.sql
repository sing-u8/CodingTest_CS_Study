-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/151139
-- 대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기
-- 레벨3

--- MYSQL

WITH TARGET_CARS AS (
    SELECT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
    GROUP BY CAR_ID
    HAVING COUNT(HISTORY_ID) >= 5
)

SELECT
    MONTH(START_DATE) AS MONTH,
    CAR_ID,
    COUNT(HISTORY_ID) AS RECORDS
FROM
    CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE
    START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
  AND CAR_ID IN (SELECT CAR_ID FROM TARGET_CARS)
GROUP BY
    MONTH(START_DATE),
    CAR_ID
ORDER BY
    MONTH ASC,
    CAR_ID DESC;


/*

 안녕하세요! 코딩 테스트 마스터입니다. 가져오신 문제를 꼼꼼히 분석해 보았습니다. 이 문제는 프로그래머스 SQL 고득점 Kit의 **"대여 횟수가 많은 자동차들의 월별 대여 횟수 구하기"** (Level 3) 문제입니다.

이 문제에는 정답률을 대폭 깎아먹는 **매우 중요한 함정**이 하나 숨어있습니다. 이 함정을 어떻게 논리적으로 돌파하는지 2가지 접근 방식을 통해 명쾌하게 해설해 드리겠습니다.

---

### 🚨 핵심 함정 포인트 (주의!)

가장 흔하게 하는 실수는 단일 쿼리에서 `GROUP BY MONTH, CAR_ID`를 한 뒤, `HAVING COUNT(*) >= 5`를 적용하는 것입니다.
이렇게 하면 **"특정 달에 5번 이상 대여된 자동차"**를 찾게 되어 완전히 틀린 결과가 나옵니다.

문제의 요구사항은 다음과 같습니다.

1. **조건:** '2022년 8월 ~ 10월' 기간 **전체**를 합산하여 총 대여 횟수가 5회 이상인 `CAR_ID`를 찾는다.
2. **결과:** 위에서 찾은 `CAR_ID`들만 대상으로, **월별**로 대여 횟수를 다시 집계한다.

따라서 이 문제는 **조건을 만족하는 대상(CAR_ID)을 먼저 추려내는 서브쿼리**가 반드시 필요합니다.

---

### 💡 풀이 1: `IN` 연산자를 활용한 서브쿼리 (가장 표준적인 방법)

가장 직관적이고 널리 쓰이는 패턴입니다. 서브쿼리로 VIP 자동차(5회 이상 대여)들의 ID 목록을 뽑아낸 뒤, 메인 쿼리에서 해당 ID들만 필터링하여 월별로 집계합니다.

**SQL 코드 (MySQL 기준):**

```sql
SELECT
    MONTH(START_DATE) AS MONTH,
    CAR_ID,
    COUNT(*) AS RECORDS
FROM
    CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE
    -- 1. 메인 쿼리에서도 8월~10월 데이터만 대상으로 제한해야 합니다.
    START_DATE >= '2022-08-01' AND START_DATE < '2022-11-01'
    -- 2. 서브쿼리에서 추출한 "총 대여 횟수 5회 이상"인 자동차 ID만 필터링합니다.
    AND CAR_ID IN (
        SELECT CAR_ID
        FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
        WHERE START_DATE >= '2022-08-01' AND START_DATE < '2022-11-01'
        GROUP BY CAR_ID
        HAVING COUNT(*) >= 5
    )
GROUP BY
    MONTH(START_DATE),
    CAR_ID
HAVING
    RECORDS > 0 -- 총 대여 횟수가 0인 경우 제외 (COUNT 특성상 생략해도 무방하나 명시적 표현)
ORDER BY
    MONTH ASC,
    CAR_ID DESC;

```

**🔍 코드 단계별 해설:**

* **서브쿼리 (`IN` 내부):** 지정된 기간 내에 대여 기록을 `CAR_ID`로 묶었을 때(`GROUP BY`), 그 개수가 5개 이상(`HAVING COUNT(*) >= 5`)인 `CAR_ID` 목록을 반환합니다. (예: ID 1, 2)
* **메인 쿼리 `WHERE` 조건:** 서브쿼리에 속한 차들이라도 11월이나 7월 기록이 섞여 들어오면 안 되므로, 메인 쿼리에서도 다시 한번 `START_DATE` 기간 조건을 명시해야 합니다.
* **그룹화 및 정렬:** 월(`MONTH`)과 자동차 ID(`CAR_ID`)를 기준으로 다시 그룹화한 뒤, 요구사항에 맞게 정렬(`ORDER BY`)합니다.

---

### 💡 풀이 2: `WITH` 절 (CTE)을 활용한 가독성 높은 쿼리 (모던 SQL)

서브쿼리가 `WHERE` 절 안에 들어가면 코드가 길어지고 읽기 어려워질 수 있습니다. 최신 SQL에서 지원하는 `WITH` 절(Common Table Expression)을 사용하면, 복잡한 조건을 미리 정의해 두고 메인 쿼리를 깔끔하게 작성할 수 있습니다.

**SQL 코드 (MySQL 8.0 이상 / Oracle):**

```sql
-- 1. 5회 이상 대여된 타겟 자동차 목록을 임시 테이블(TARGET_CARS)로 만듭니다.
WITH TARGET_CARS AS (
    SELECT CAR_ID
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY
    WHERE START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
    GROUP BY CAR_ID
    HAVING COUNT(HISTORY_ID) >= 5
)

-- 2. 메인 로직 처리
SELECT
    MONTH(START_DATE) AS MONTH,
    CAR_ID,
    COUNT(HISTORY_ID) AS RECORDS
FROM
    CAR_RENTAL_COMPANY_RENTAL_HISTORY
WHERE
    START_DATE BETWEEN '2022-08-01' AND '2022-10-31'
    AND CAR_ID IN (SELECT CAR_ID FROM TARGET_CARS)
GROUP BY
    MONTH(START_DATE),
    CAR_ID
ORDER BY
    MONTH ASC,
    CAR_ID DESC;

```

**🔍 두 방식의 차이점 및 장단점:**

* 로직 자체는 완전히 동일합니다.
* 하지만 `WITH` 절을 사용하면 **"내가 어떤 데이터를 먼저 전처리했는지"** (이 경우엔 `TARGET_CARS`) 명시적으로 이름을 붙일 수 있어, 실무에서 복잡한 쿼리를 작성할 때 유지보수성과 가독성이 압도적으로 높아집니다.

---

### 📊 시각적 요약: 왜 메인 쿼리에도 날짜 필터가 필요한가?

많은 분들이 서브쿼리에서 날짜를 필터링했으니 메인 쿼리에서는 안 해도 된다고 착각합니다. 다음과 같은 상황을 보시죠.

| CAR_ID | START_DATE | 서브쿼리 통과? (8~10월 5회 이상) | 메인 쿼리에 날짜 필터가 없다면? |
| --- | --- | --- | --- |
| **1** | 2022-08-15 | **통과 (O)** | 8월 집계에 포함 (정상) |
| **1** | 2022-11-05 | 이미 통과한 차 | **11월 집계에 뜬금없이 포함됨 (오답) ❌** |

위 표처럼, 조건(8~10월 5회 이상)을 만족하는 'CAR_ID 1번' 차량이 11월에도 렌트를 했다면, 메인 쿼리에서 날짜를 다시 잘라주지 않을 경우 11월 기록까지 결과에 섞여 나오게 됩니다. 따라서 **서브쿼리와 메인 쿼리 양쪽 모두 날짜 필터링을 걸어주는 것**이 이 문제의 두 번째 핵심입니다.

 */