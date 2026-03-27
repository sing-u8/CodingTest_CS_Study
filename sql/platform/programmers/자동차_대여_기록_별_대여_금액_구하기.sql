-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/151141
-- 자동차 대여 기록 별 대여 금액 구하기
-- 레벨4

--- answer 1: REGEXP_REPLACE + 서브쿼리 MAX 방식

WITH TRUCK_DISCOUNT AS (
    SELECT
        PLAN_ID,
        DISCOUNT_RATE,
        CAST(REGEXP_REPLACE(DURATION_TYPE, '[^0-9]', '') AS UNSIGNED) AS DURATION
    FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN
    WHERE CAR_TYPE = '트럭'
),
TRUCK_HISTORY AS (
    SELECT
        CH.HISTORY_ID,
        CC.DAILY_FEE,
        (DATEDIFF(CH.END_DATE, CH.START_DATE) + 1) AS RENT_DAYS
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY CH
    INNER JOIN CAR_RENTAL_COMPANY_CAR CC
        ON CH.CAR_ID = CC.CAR_ID
    WHERE CC.CAR_TYPE = '트럭'
)

SELECT
    TH.HISTORY_ID,
    FLOOR(
        TH.DAILY_FEE * TH.RENT_DAYS * (100 - IFNULL((
            SELECT (MAX(DISCOUNT_RATE))
            FROM TRUCK_DISCOUNT TD
            WHERE TH.RENT_DAYS >= TD.DURATION
        ), 0)) / 100) AS FEE
FROM TRUCK_HISTORY TH
ORDER BY
    FEE DESC,
    TH.HISTORY_ID DESC;

------

--- answer 2: CASE WHEN + LEFT JOIN 방식

WITH TRUCK_HISTORY AS (
    SELECT
        H.HISTORY_ID,
        C.DAILY_FEE,
        (DATEDIFF(H.END_DATE, H.START_DATE) + 1) AS RENT_DAYS,
        CASE
            WHEN DATEDIFF(H.END_DATE, H.START_DATE) + 1 >= 90 THEN '90일 이상'
            WHEN DATEDIFF(H.END_DATE, H.START_DATE) + 1 >= 30 THEN '30일 이상'
            WHEN DATEDIFF(H.END_DATE, H.START_DATE) + 1 >= 7 THEN '7일 이상'
            ELSE NULL
        END AS DURATION_TYPE
    FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
    INNER JOIN CAR_RENTAL_COMPANY_CAR C
      ON H.CAR_ID = C.CAR_ID
    WHERE C.CAR_TYPE = '트럭'
)

SELECT
    T.HISTORY_ID,
    FLOOR(T.DAILY_FEE * T.RENT_DAYS * (100 - IFNULL(P.DISCOUNT_RATE, 0)) / 100) AS FEE
FROM TRUCK_HISTORY T
LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
    ON T.DURATION_TYPE = P.DURATION_TYPE
    AND P.CAR_TYPE = '트럭'
ORDER BY
    FEE DESC,
    T.HISTORY_ID DESC;

------

--- answer 3: CTE 없이 인라인 서브쿼리 방식

SELECT
    H.HISTORY_ID,
    FLOOR(
        C.DAILY_FEE
        * (DATEDIFF(H.END_DATE, H.START_DATE) + 1)
        * (100 - IFNULL((
            SELECT MAX(P.DISCOUNT_RATE)
            FROM CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
            WHERE P.CAR_TYPE = '트럭'
              AND (DATEDIFF(H.END_DATE, H.START_DATE) + 1)
                  >= CAST(REGEXP_REPLACE(P.DURATION_TYPE, '[^0-9]', '') AS UNSIGNED)
        ), 0))
        / 100
    ) AS FEE
FROM CAR_RENTAL_COMPANY_RENTAL_HISTORY H
INNER JOIN CAR_RENTAL_COMPANY_CAR C
    ON H.CAR_ID = C.CAR_ID
WHERE C.CAR_TYPE = '트럭'
ORDER BY
    FEE DESC,
    H.HISTORY_ID DESC;


/*

## 문제 요약

**테이블 3개**를 활용하여 **트럭** 차종의 대여 기록별 대여 금액을 구하는 문제입니다.

| 테이블 | 역할 |
|--------|------|
| `CAR_RENTAL_COMPANY_CAR` | 차량 정보 (CAR_ID, CAR_TYPE, DAILY_FEE) |
| `CAR_RENTAL_COMPANY_RENTAL_HISTORY` | 대여 기록 (HISTORY_ID, CAR_ID, START_DATE, END_DATE) |
| `CAR_RENTAL_COMPANY_DISCOUNT_PLAN` | 할인 정책 (CAR_TYPE, DURATION_TYPE, DISCOUNT_RATE) |

**핵심 로직:**
1. 트럭만 필터링
2. 대여일수 = `DATEDIFF(END_DATE, START_DATE) + 1`
3. 대여일수에 맞는 할인율 적용 (7일 이상 / 30일 이상 / 90일 이상)
4. 금액 = `FLOOR(일일요금 × 대여일수 × (100 - 할인율) / 100)`
5. 할인 구간에 해당하지 않으면 할인율 0% (정가)

---

## 💡 Answer 1 해설: REGEXP_REPLACE + 서브쿼리 MAX 방식

### 전략
CTE를 **2개**로 분리하여 할인 정보와 대여 이력을 각각 전처리한 뒤, 메인 쿼리에서 서브쿼리로 최대 할인율을 조회합니다.

### CTE 1: TRUCK_DISCOUNT — 할인 테이블 전처리

```sql
CAST(REGEXP_REPLACE(DURATION_TYPE, '[^0-9]', '') AS UNSIGNED) AS DURATION
```

이 한 줄이 이 풀이의 핵심입니다:

```text
DURATION_TYPE 원본    → REGEXP_REPLACE 결과 → CAST 결과
'7일 이상'           → '7'                → 7
'30일 이상'          → '30'               → 30
'90일 이상'          → '90'               → 90
```

- `REGEXP_REPLACE(DURATION_TYPE, '[^0-9]', '')` : 숫자가 아닌 문자(`[^0-9]`)를 모두 빈 문자열로 치환 → 숫자만 남음
- `CAST(... AS UNSIGNED)` : 문자열 '7'을 정수 7로 변환 → 대소 비교 가능

### CTE 2: TRUCK_HISTORY — 트럭 대여 이력

차량 테이블과 대여 이력을 INNER JOIN하여 트럭만 필터링하고, 대여일수를 계산합니다.

### 메인 쿼리: 상관 서브쿼리로 할인율 조회

```sql
SELECT MAX(DISCOUNT_RATE)
FROM TRUCK_DISCOUNT TD
WHERE TH.RENT_DAYS >= TD.DURATION
```

대여일수 이하인 DURATION 중 **가장 큰 할인율**을 선택합니다.

```text
예) 대여일수 = 45일
  → 45 >= 7 (5% 할인) ✓
  → 45 >= 30 (7% 할인) ✓
  → 45 >= 90 (8% 할인) ✗
  → MAX(5, 7) = 7% 적용
```

할인 구간에 해당하지 않는 경우(예: 대여일수 3일) 서브쿼리 결과가 NULL이므로 `IFNULL(..., 0)`으로 할인율 0%를 적용합니다.

### 특징
- **장점**: DURATION_TYPE의 숫자를 동적으로 추출하므로 할인 구간이 추가/변경되어도 쿼리 수정 불필요
- **단점**: `REGEXP_REPLACE`는 MySQL 8.0+에서만 지원, 상관 서브쿼리로 행마다 서브쿼리 실행

---

## 💡 Answer 2 해설: CASE WHEN + LEFT JOIN 방식

### 전략
CTE에서 대여일수를 기반으로 `CASE WHEN`으로 직접 DURATION_TYPE 문자열을 매핑한 뒤, 할인 정책 테이블과 LEFT JOIN합니다.

### 핵심: CASE WHEN 분류

```sql
CASE
    WHEN DATEDIFF(...) + 1 >= 90 THEN '90일 이상'
    WHEN DATEDIFF(...) + 1 >= 30 THEN '30일 이상'
    WHEN DATEDIFF(...) + 1 >= 7  THEN '7일 이상'
    ELSE NULL
END AS DURATION_TYPE
```

**CASE WHEN은 위에서부터 순서대로 평가**되므로, 90일 이상 조건을 먼저 검사해야 합니다.
만약 순서를 바꾸면(7일 이상을 먼저 쓰면) 90일짜리도 '7일 이상'에 걸려버립니다.

```text
대여일수     → CASE 결과      → JOIN 결과
3일         → NULL           → LEFT JOIN이므로 NULL → IFNULL(NULL, 0) = 0%
10일        → '7일 이상'      → 5%
45일        → '30일 이상'     → 7%
100일       → '90일 이상'     → 8%
```

### LEFT JOIN의 역할

```sql
LEFT JOIN CAR_RENTAL_COMPANY_DISCOUNT_PLAN P
    ON T.DURATION_TYPE = P.DURATION_TYPE
    AND P.CAR_TYPE = '트럭'
```

- `LEFT JOIN`을 사용하는 이유: DURATION_TYPE이 NULL인 경우(7일 미만 대여)에도 결과에 포함시키기 위함
- `INNER JOIN`을 사용하면 할인 구간에 해당하지 않는 기록이 누락됨

### 특징
- **장점**: 직관적이고 가독성이 높음, LEFT JOIN으로 한 번에 처리하므로 성능 우수
- **단점**: 할인 구간('7일 이상', '30일 이상', '90일 이상')이 CASE WHEN에 하드코딩됨

---

## 💡 Answer 3 (추가 대안): CTE 없이 인라인 서브쿼리 방식

Answer 1과 동일한 로직(REGEXP_REPLACE + MAX 서브쿼리)이지만, CTE 없이 모든 것을 하나의 SELECT 문으로 처리합니다.

### 특징
- **장점**: 단일 쿼리로 간결함
- **단점**: 가독성이 떨어지고, `DATEDIFF(H.END_DATE, H.START_DATE) + 1`이 SELECT와 서브쿼리에서 중복 계산됨

---

## 🔍 세 풀이 비교

| 항목 | Answer 1 | Answer 2 | Answer 3 |
|------|----------|----------|----------|
| 할인율 매칭 | 서브쿼리 MAX | CASE WHEN + LEFT JOIN | 서브쿼리 MAX |
| 하드코딩 여부 | 없음 (동적 추출) | 있음 (CASE에 구간 직접 기술) | 없음 (동적 추출) |
| CTE 사용 | 2개 | 1개 | 없음 |
| 가독성 | 보통 | 높음 | 낮음 |
| DB 이식성 | 낮음 (REGEXP) | 높음 | 낮음 (REGEXP) |
| 추천 상황 | 할인 구간이 유동적일 때 | 코딩 테스트 (가독성 중시) | 짧은 코드 선호 시 |

---

## 📚 REGEXP_REPLACE 함수 정리

### 기본 문법 (MySQL 8.0+)

```sql
REGEXP_REPLACE(expr, pattern, replacement)
```

- `expr`: 원본 문자열
- `pattern`: 정규표현식 패턴
- `replacement`: 치환할 문자열

### 주요 사용 예시

```sql
-- 1. 숫자만 추출 (숫자가 아닌 문자 모두 제거)
SELECT REGEXP_REPLACE('7일 이상', '[^0-9]', '');
-- 결과: '7'

-- 2. 알파벳만 추출
SELECT REGEXP_REPLACE('abc123def', '[^a-zA-Z]', '');
-- 결과: 'abcdef'

-- 3. 연속된 공백을 하나로 축소
SELECT REGEXP_REPLACE('hello    world', '\\s+', ' ');
-- 결과: 'hello world'

-- 4. 특수문자 제거
SELECT REGEXP_REPLACE('user@name#test!', '[^a-zA-Z0-9]', '');
-- 결과: 'usernametest'

-- 5. 전화번호 포맷팅
SELECT REGEXP_REPLACE('01012345678', '([0-9]{3})([0-9]{4})([0-9]{4})', '\\1-\\2-\\3');
-- 결과: '010-1234-5678'
```

### 정규표현식 주요 패턴

| 패턴 | 의미 | 예시 |
|------|------|------|
| `[0-9]` | 숫자 한 글자 | `'5'` 매칭 |
| `[^0-9]` | 숫자가 아닌 한 글자 | `'일'`, `' '` 매칭 |
| `\\d` | 숫자 (= `[0-9]`) | MySQL에서는 `\\d` 사용 |
| `\\s` | 공백 문자 | 스페이스, 탭, 줄바꿈 |
| `+` | 1회 이상 반복 | `[0-9]+` → 연속된 숫자 |
| `*` | 0회 이상 반복 | `[a-z]*` → 소문자 0개 이상 |

### DB별 지원 현황

| DB | 함수명 | 지원 버전 |
|----|--------|-----------|
| MySQL | `REGEXP_REPLACE()` | 8.0+ |
| Oracle | `REGEXP_REPLACE()` | 10g+ |
| PostgreSQL | `REGEXP_REPLACE()` | 전 버전 (기본 첫 번째만 치환, 전체 치환은 플래그 `'g'` 필요) |
| SQL Server | 미지원 | CLR 함수 또는 패턴 반복 `REPLACE` 필요 |

### PostgreSQL 주의사항

```sql
-- PostgreSQL에서 모든 매칭을 치환하려면 'g' 플래그 필요
SELECT REGEXP_REPLACE('7일 이상', '[^0-9]', '', 'g');
-- 'g' 없으면 첫 번째 매칭만 치환
```

---

## 📚 CAST 함수 정리

### 기본 문법

```sql
CAST(expr AS type)
```

- `expr`: 변환할 값 또는 표현식
- `type`: 변환 대상 데이터 타입

### MySQL에서 사용 가능한 주요 타입

| 타입 | 설명 | 예시 |
|------|------|------|
| `UNSIGNED` | 부호 없는 정수 (0 이상) | `CAST('42' AS UNSIGNED)` → 42 |
| `SIGNED` | 부호 있는 정수 | `CAST('-5' AS SIGNED)` → -5 |
| `CHAR` | 문자열 | `CAST(123 AS CHAR)` → '123' |
| `DATE` | 날짜 (YYYY-MM-DD) | `CAST('2024-01-15' AS DATE)` |
| `DATETIME` | 날짜+시간 | `CAST('2024-01-15 10:30:00' AS DATETIME)` |
| `DECIMAL(M,D)` | 고정소수점 | `CAST(3.14159 AS DECIMAL(5,2))` → 3.14 |
| `FLOAT` | 부동소수점 | `CAST('3.14' AS FLOAT)` |
| `BINARY` | 바이너리 문자열 | 인코딩 변환 시 사용 |
| `JSON` | JSON 타입 (MySQL 5.7.8+) | `CAST('{"a":1}' AS JSON)` |

### 실전 활용 패턴

```sql
-- 1. 문자열 → 정수 변환 (숫자 비교용)
SELECT CAST('100' AS UNSIGNED) > 50;
-- 결과: 1 (TRUE)

-- 2. REGEXP_REPLACE와 조합 (이 문제에서 사용한 패턴)
SELECT CAST(REGEXP_REPLACE('30일 이상', '[^0-9]', '') AS UNSIGNED);
-- 결과: 30

-- 3. 날짜 형식 변환
SELECT CAST('20240115' AS DATE);
-- 결과: '2024-01-15'

-- 4. 소수점 자릿수 제어
SELECT CAST(100/3 AS DECIMAL(10, 2));
-- 결과: 33.33

-- 5. 정렬 시 문자열을 숫자로 취급
SELECT * FROM items ORDER BY CAST(price_text AS UNSIGNED);
```

### CAST vs CONVERT (MySQL)

```sql
-- 동일한 결과
CAST('123' AS UNSIGNED)
CONVERT('123', UNSIGNED)
```

| 항목 | CAST | CONVERT |
|------|------|---------|
| 표준 SQL | O (ANSI SQL) | X (MySQL/SQL Server 확장) |
| 문법 | `CAST(expr AS type)` | `CONVERT(expr, type)` |
| 이식성 | 높음 (대부분의 DB 지원) | 낮음 (DB마다 문법 다름) |
| 권장 | 코딩 테스트 및 범용 사용 시 | MySQL 전용 코드 작성 시 |

> **코딩 테스트 팁**: `CAST`는 표준 SQL이므로 어떤 DB에서든 사용 가능합니다. `CONVERT`는 MySQL과 SQL Server에서 문법이 다르므로, 이식성을 고려하면 `CAST`를 쓰는 것이 안전합니다.

### 암시적 형변환 주의

MySQL은 문자열과 숫자를 비교할 때 **암시적 형변환**을 수행하지만, 이에 의존하면 예기치 않은 결과가 발생할 수 있습니다:

```sql
-- 위험: 암시적 형변환
SELECT '7' > 30;   -- 결과: 0 (FALSE) — 숫자로 비교됨, 문제 없어 보이지만...
SELECT '7abc' > 30; -- 결과: 0 — '7abc'가 7로 변환됨 (경고 발생)

-- 안전: 명시적 CAST 사용
SELECT CAST('7' AS UNSIGNED) > 30;  -- 의도가 명확
```

> 명시적 `CAST`를 사용하면 코드의 의도가 분명해지고, 타입 관련 버그를 예방할 수 있습니다.

*/
