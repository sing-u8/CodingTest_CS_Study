-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/164670
-- 조건에 맞는 사용자 정보 조회하기
-- 레벨3

--- MySQL

WITH HEAVY_USERS AS (
    SELECT WRITER_ID
    FROM USED_GOODS_BOARD
    GROUP BY WRITER_ID
    HAVING COUNT(BOARD_ID) >= 3
)

SELECT
    U.USER_ID,
    U.NICKNAME,
    CONCAT_WS(' ', U.CITY, U.STREET_ADDRESS1, U.STREET_ADDRESS2) AS 전체주소,
    CONCAT_WS('-', SUBSTRING(U.TLNO, 1, 3), SUBSTRING(U.TLNO, 4, 4), SUBSTRING(U.TLNO, 8, 4)) AS 전화번호
FROM USED_GOODS_USER U
JOIN HEAVY_USERS H
    ON U.USER_ID = H.WRITER_ID
ORDER BY U.USER_ID DESC;

---

SELECT
	U.USER_ID,
    U.NICKNAME,
    CONCAT(U.CITY, ' ', U.STREET_ADDRESS1, ' ', U.STREET_ADDRESS2) AS 전체주소,
    CONCAT(SUBSTRING(U.TLNO, 1, 3), '-', SUBSTRING(U.TLNO, 4, 4), '-', SUBSTRING(U.TLNO, 8, 4)) AS 전화번호
FROM USED_GOODS_USER U
JOIN USED_GOODS_BOARD B
  ON U.USER_ID = B.WRITER_ID
GROUP BY U.USER_ID
HAVING COUNT(B.BOARD_ID) >= 3
ORDER BY U.USER_ID DESC;



/*

---

## 📌 문제 핵심 목표
1. **대상 찾기**: 중고 거래 게시판(`USED_GOODS_BOARD`)에 글을 **3건 이상** 올린 회원(`USED_GOODS_USER`) 찾기
2. **데이터 가공 (문자열)**:
    * 주소 3개(시, 도로명, 상세주소)를 띄어쓰기로 합치기
    * 11자리 전화번호 사이에 하이픈(`-`) 넣기
3. **정렬**: 회원 ID 기준 내림차순(`DESC`)

---

## 💡 풀이 1: 코딩 테스트의 정석 (`SUBSTRING` + `CONCAT`)
어떤 데이터베이스(MySQL, Oracle 등)를 쓰든 100% 안전하게 동작하는 가장 표준적이고 직관적인 풀이입니다.

```sql
SELECT
    U.USER_ID,
    U.NICKNAME,
    -- 1. 주소 합치기: CONCAT은 괄호 안의 문자열을 순서대로 이어 붙입니다.
    -- 중간에 띄어쓰기를 위해 ' ' 문자열을 직접 끼워 넣었습니다.
    CONCAT(U.CITY, ' ', U.STREET_ADDRESS1, ' ', U.STREET_ADDRESS2) AS 전체주소,

    -- 2. 전화번호 포맷팅: SUBSTRING으로 필요한 만큼 자르고 CONCAT으로 '-'와 함께 조립합니다.
    CONCAT(SUBSTRING(U.TLNO, 1, 3), '-', SUBSTRING(U.TLNO, 4, 4), '-', SUBSTRING(U.TLNO, 8, 4)) AS 전화번호

FROM USED_GOODS_USER U
JOIN USED_GOODS_BOARD B
  ON U.USER_ID = B.WRITER_ID
-- 3. 회원별로 그룹화합니다.
GROUP BY U.USER_ID
-- 4. 그룹화된 결과 중, 게시글이 3개 이상인 그룹(회원)만 남깁니다.
HAVING COUNT(B.BOARD_ID) >= 3
ORDER BY U.USER_ID DESC;
```

### 🔍 상세 해설 (왜 이렇게 작동할까요?)
* **`JOIN`과 `GROUP BY`의 흐름**: 사용자와 게시글 테이블을 연결하면, 사용자가 쓴 글의 개수만큼 데이터(행)가 늘어납니다. 이를 다시 `USER_ID` 기준으로 묶어(`GROUP BY`) 하나의 그룹으로 압축한 뒤, `HAVING COUNT(B.BOARD_ID) >= 3`을 통해 글을 3개 이상 쓴 사람만 솎아냅니다.
* **`SUBSTRING(문자열, 시작점, 길이)`**: SQL에서 문자열의 위치는 0이 아닌 **1부터 시작**합니다.
    * `SUBSTRING('01012345678', 1, 3)` ➔ 1번째 글자부터 3개 자름 ➔ **010**
    * `SUBSTRING('01012345678', 4, 4)` ➔ 4번째 글자부터 4개 자름 ➔ **1234**
    * `SUBSTRING('01012345678', 8, 4)` ➔ 8번째 글자부터 4개 자름 ➔ **5678**
* **레고 조립(`CONCAT`)**: 잘라낸 3개의 조각을 `CONCAT(조각1, '-', 조각2, '-', 조각3)` 처럼 하이픈을 본드 삼아 이어 붙이는 원리입니다.

---

## 💡 풀이 2: 가독성과 안전성 극대화 (`WITH` 절 + `CONCAT_WS`)

실무에서 가장 환영받는 코드 스타일입니다. 복잡한 조건을 위로 빼내고, 결측치(`NULL`)에 안전한 함수를 사용합니다.

```sql
-- 1. [데이터 준비] 글을 3건 이상 쓴 회원의 ID만 먼저 찾아 임시 테이블(HEAVY_USERS)로 만듭니다.
WITH HEAVY_USERS AS (
    SELECT WRITER_ID
    FROM USED_GOODS_BOARD
    GROUP BY WRITER_ID
    HAVING COUNT(BOARD_ID) >= 3
)

SELECT
    U.USER_ID,
    U.NICKNAME,

    -- 2. CONCAT_WS('구분자', 값1, 값2...): 첫 번째 인자로 띄어쓰기(' ')를 주면, 뒤에 오는 값들 사이에 자동으로 띄어쓰기를 넣어줍니다.
    CONCAT_WS(' ', U.CITY, U.STREET_ADDRESS1, U.STREET_ADDRESS2) AS 전체주소,

    -- 3. 첫 번째 인자로 하이픈('-')을 주어 잘라낸 번호들을 연결합니다.
    CONCAT_WS('-', SUBSTRING(U.TLNO, 1, 3), SUBSTRING(U.TLNO, 4, 4), SUBSTRING(U.TLNO, 8, 4)) AS 전화번호

FROM USED_GOODS_USER U
-- 4. 원본 사용자 테이블과 위에서 만든 임시 테이블을 결합하여, 조건에 맞는 사람만 남깁니다.
JOIN HEAVY_USERS H
  ON U.USER_ID = H.WRITER_ID
ORDER BY U.USER_ID DESC;
```

### 🔍 상세 해설 (왜 이 코드가 실무형일까요?)
* **논리의 분리 (`WITH`)**: "조건에 맞는 사람 찾기"와 "정보 예쁘게 출력하기" 두 가지 작업을 분리했습니다. 코드를 읽는 사람이 쿼리의 목적을 파악하기 훨씬 쉽습니다.
* **`CONCAT_WS`의 마법**: 만약 상세 주소(`STREET_ADDRESS2`)를 입력하지 않은 회원이 있다면 값이 `NULL`이 됩니다. 일반 `CONCAT`은 문자열 중 하나라도 `NULL`이면 전체를 `NULL`로 만들어버려 주소가 통째로 날아가지만, **`CONCAT_WS`는 `NULL`을 만나면 투명인간 취급하고 나머지 문자열만 안전하게 연결**해 줍니다.

---

## 💡 풀이 3: 코드의 최소화, 정규 표현식 (`REGEXP_REPLACE`)
코드를 가장 짧고 세련되게 작성할 수 있는 고급 기술입니다. 최신 데이터베이스(MySQL 8.0 이상)에서 사용합니다.

```sql
SELECT
    U.USER_ID,
    U.NICKNAME,
    CONCAT_WS(' ', U.CITY, U.STREET_ADDRESS1, U.STREET_ADDRESS2) AS 전체주소,

    -- REGEXP_REPLACE(원본컬럼, '찾을 패턴', '바꿀 형태')
    -- 숫자 3개, 4개, 4개 덩어리를 찾아서 각각 $1, $2, $3 메모리에 저장하고, 사이에 '-'를 넣어 꺼냅니다.
    REGEXP_REPLACE(U.TLNO, '([0-9]{3})([0-9]{4})([0-9]{4})', '$1-$2-$3') AS 전화번호

FROM USED_GOODS_USER U
JOIN USED_GOODS_BOARD B
  ON U.USER_ID = B.WRITER_ID
GROUP BY U.USER_ID
HAVING COUNT(B.BOARD_ID) >= 3
ORDER BY U.USER_ID DESC;
```

### 🔍 상세 해설 (정규식 주문서 해독)
* **`([0-9]{3})`**:
    * `[0-9]`: 0부터 9까지의 숫자를 의미합니다.
    * `{3}`: 바로 앞의 조건(숫자)이 딱 3번 반복된다는 뜻입니다.
    * `()`: 괄호로 묶으면 '캡처 그룹'이 되어, 찾아낸 값을 임시 메모리 1번 방(`$1`)에 저장합니다.
* **패턴의 연결**: 위와 같은 방식으로 3자리(`$1`), 4자리(`$2`), 4자리(`$3`) 숫자를 순서대로 찾아 메모리에 담습니다.
* **`'$1-$2-$3'`**:
    * "메모리 1번 방 내용 꺼내고, 하이픈 긋고, 2번 방 내용 꺼내고, 하이픈 긋고, 3번 방 내용 꺼내 줘!"라는 출력 지시어입니다. 번거로운 `SUBSTRING` 3줄을 단 한 줄로 끝낼 수 있습니다. (Oracle의 경우 `$1` 대신 `\1`을 사용합니다.)

---
 */