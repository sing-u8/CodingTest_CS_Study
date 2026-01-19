-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131120?language=oracle
-- 3월에 태어난 여성 회원 목록 출력하기
-- 레벨2

-- ORACLE
SELECT
    MEMBER_ID,
    MEMBER_NAME,
    GENDER,
    TO_CHAR(DATE_OF_BIRTH, 'YYYY-MM-DD') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE TLNO IS NOT NULL
  AND GENDER = 'W'
  AND TO_CHAR(DATE_OF_BIRTH, 'MM') = '03'
ORDER BY MEMBER_ID ASC;


-- MYSQL
SELECT
    MEMBER_ID,
    MEMBER_NAME,
    GENDER,
    DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE TLNO IS NOT NULL
          AND GENDER = 'W'
          AND MONTH(DATE_OF_BIRTH) = 3
ORDER BY MEMBER_ID ASC;


/*

SELECT
    MEMBER_ID,
    MEMBER_NAME,
    GENDER,
    TO_CHAR(DATE_OF_BIRTH, 'YYYY-MM-DD') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE TLNO != NULL
    AND (DATE_OF_BIRTH >= TO_DATE('03-01', 'MM-DD')
         AND DATE_OF_BIRTH < TO_DATE('04-01', 'MM-DD'))
ORDER BY MEMBER_ID ASC;

작성하신 쿼리에서 데이터가 조회되지 않는 이유는 크게 두 가지입니다. **`NULL` 값을 처리하는 방식**과 **날짜를 비교하는 방식**에서 SQL 문법적 오류와 논리적 오류가 있었습니다.

특히 `NULL` 처리는 SQLD 시험이나 실무 면접에서 가장 많이 묻는 "함정" 중 하나이니 이번 기회에 확실히 익혀두시면 좋습니다.

요청하신 대로 **실무에서 사용하는 효율적인 모범 답안**과 함께, 작성하신 쿼리가 왜 작동하지 않았는지 친절하게 설명해 드릴게요.

---

### 1. 문제 원인 분석

작성하신 쿼리에는 두 가지 수정이 필요합니다.

#### ① `TLNO != NULL` (가장 큰 원인)

SQL에서 `NULL`은 "0"이나 "공백"이라는 값이 아니라 **'값이 존재하지 않음(Unknown)'**을 의미하는 상태입니다.
따라서 `=` (같다)나 `!=` (다르다)와 같은 일반 비교 연산자로는 `NULL`을 판단할 수 없습니다. `NULL`과의 연산 결과는 무조건 `NULL`(알 수 없음)이 되어버리기 때문에, `WHERE` 절이 모든 행을 `FALSE`로 인식하여 아무 결과도 나오지 않은 것입니다.

* **잘못된 표현:** `TLNO != NULL`
* **올바른 표현:** `TLNO IS NOT NULL`

#### ② 날짜 비교 (`TO_DATE`)

작성하신 `TO_DATE('03-01', 'MM-DD')`는 연도(Year) 정보를 주지 않았기 때문에, 데이터베이스 시스템의 **현재 연도(예: 2024년, 2025년)** 또는 **기본 연도(0001년)**로 자동 설정됩니다.
회원들의 생일은 1992년, 1993년인데 비교 대상은 2024년 3월이 되므로, 조건이 일치하지 않게 됩니다. 생일 검색은 연도와 상관없이 **"월(Month)"**만 추출해서 비교해야 합니다.

---

### 2. 모범 답안 (SQL Solution)

가장 범용적이고 실무에서 많이 쓰이는 **Oracle/PostgreSQL** 기준 쿼리와, 코딩 테스트(프로그래머스 등)에서 자주 쓰이는 **MySQL** 기준 쿼리를 나누어 드립니다. (작성하신 `TO_CHAR` 문법을 보아 Oracle/PostgreSQL 문법을 선호하시는 것으로 보입니다.)

#### [Option A] Oracle / PostgreSQL (추천)

`TO_CHAR` 함수를 사용하여 날짜 형식을 지정하고, 월을 추출합니다.

```sql
SELECT
    MEMBER_ID,
    MEMBER_NAME,
    GENDER,
    TO_CHAR(DATE_OF_BIRTH, 'YYYY-MM-DD') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE TLNO IS NOT NULL              -- 1. 전화번호가 NULL이 아닌 경우
    AND GENDER = 'W'                -- 2. 성별이 여성인 경우
    AND TO_CHAR(DATE_OF_BIRTH, 'MM') = '03' -- 3. 생일이 3월인 경우 (월만 추출하여 비교)
ORDER BY MEMBER_ID ASC;             -- 4. 회원ID 기준 오름차순 정렬

```

#### [Option B] MySQL

MySQL에서는 `DATE_FORMAT`과 `MONTH` 함수를 주로 사용합니다.

```sql
SELECT
    MEMBER_ID,
    MEMBER_NAME,
    GENDER,
    DATE_FORMAT(DATE_OF_BIRTH, '%Y-%m-%d') AS DATE_OF_BIRTH
FROM MEMBER_PROFILE
WHERE TLNO IS NOT NULL
    AND GENDER = 'W'
    AND MONTH(DATE_OF_BIRTH) = 3
ORDER BY MEMBER_ID ASC;

```

---

### 3. 상세 설명 및 학습 포인트 (Tutor's Note)

#### 1) `WHERE TLNO IS NOT NULL`

* **동작 원리:** 컬럼의 값이 `NULL`인지 아닌지를 확인하는 전용 문법입니다.
* **필요한 이유:** 앞서 설명했듯, DB에서 `NULL`은 비교 연산(`=`, `!=`)의 대상이 될 수 없습니다. 반드시 `IS NULL` 또는 `IS NOT NULL`을 사용해야 합니다. **SQLD 시험에서 매우 자주 출제되는 함정 문제입니다.**

#### 2) `AND TO_CHAR(DATE_OF_BIRTH, 'MM') = '03'`

* **동작 원리:** `DATE` 타입인 생년월일에서 '월(Month)' 정보만 문자열('03')로 변환하여 비교합니다.
* **실무 팁:** 단순히 `DATE_OF_BIRTH LIKE '%-03-%'`와 같이 문자열 검색을 할 수도 있지만, 날짜 함수(`TO_CHAR`, `EXTRACT` 등)를 사용하는 것이 데이터 타입의 의도를 명확히 하고 오작동을 방지하는 정석적인 방법입니다.
* *참고:* 대량의 데이터에서 `WHERE` 절 좌변(컬럼)을 함수로 감싸면(`TO_CHAR(컬럼)`), 인덱스(Index)를 타지 못해 속도가 느려질 수 있습니다. 하지만 "생일 찾기"처럼 연도를 무시하고 월만 비교해야 하는 로직에서는 함수 사용이 불가피하므로, 이 방식이 표준적인 해결책입니다.



#### 3) `GENDER = 'W'`

* **필요한 이유:** 문제에서 "여성 회원"만을 요구했으므로 누락하면 안 되는 조건입니다.

#### 4) `ORDER BY MEMBER_ID ASC`

* **필요한 이유:** 결과 조회 시 정렬 순서가 맞지 않으면 오답 처리됩니다. `ASC`는 생략 가능(기본값)하지만, 명시적으로 적어주는 것이 가독성에 좋습니다.

### 요약

작성하신 쿼리에서 `!= NULL`을 **`IS NOT NULL`**로 바꾸고, 날짜 비교를 **월(Month)만 추출하여 비교**하도록 수정하면 정답입니다.

추가적인 질문이 있거나 다른 DB 환경(MySQL 등)에 대한 설명이 필요하면 언제든 물어봐 주세요!
 */