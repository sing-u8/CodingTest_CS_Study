-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/298519
-- 특정 조건을 만족하는 물고기별 수와 최대 길이 구하기
-- 레벨4

--- MYSQL

WITH FI AS (
    SELECT
        ID,
        FISH_TYPE,
        CASE
            WHEN LENGTH IS NULL THEN 10
            ELSE LENGTH
            END AS SIZE,
    TIME
FROM FISH_INFO
    )

SELECT
    COUNT(ID) AS FISH_COUNT,
    MAX(SIZE) AS MAX_LENGTH,
    FISH_TYPE
FROM FI
GROUP BY FISH_TYPE
HAVING AVG(SIZE) >= 33
ORDER BY FISH_TYPE ASC;

---


/*


 작성해주신 쿼리를 보니 `WITH` 절(CTE)과 조금 전 질문하셨던 `CASE` 문을 아주 적절하게 잘 활용하셨습니다! 논리적인 흐름을 나누어 접근하신 점이 매우 훌륭합니다.

발생한 **`Invalid use of group function`** 에러는 SQL 코딩 테스트에서 정말 자주 마주치는 단골 에러입니다. 원인과 해결책, 그리고 더 간결한 쿼리 작성법까지 명쾌하게 설명해 드리겠습니다.

*(참고: 본 문제는 데이터베이스 쿼리 문제이므로, JavaScript, C++, Java, Rust 대신 실무와 코딩 테스트에서 가장 많이 쓰이는 **MySQL**과 **Oracle** 표준 SQL을 기반으로 설명해 드리겠습니다.)*

---

### 🚨 에러의 원인: WHERE 절과 그룹 함수(Aggregate Function)의 충돌

문제의 원인은 바로 이 부분입니다:

```sql
WHERE AVG(SIZE) >= 33 -- ❌ 에러 발생 지점!
GROUP BY FISH_TYPE

```

SQL에서 `AVG()`, `COUNT()`, `MAX()`, `SUM()`과 같은 **그룹 함수(집계 함수)는 `WHERE` 절에서 사용할 수 없습니다.** 그 이유는 **SQL의 실행 순서** 때문입니다. `WHERE` 절은 데이터를 그룹화(`GROUP BY`)하기 **전**에 개별 행(Row)들을 필터링하는 역할을 합니다. 하지만 `AVG(SIZE)`는 데이터를 그룹화한 **후**에야 계산될 수 있는 값이죠. 아직 계산되지도 않은 평균값을 기준으로 필터링을 시도했기 때문에 데이터베이스 엔진이 에러를 뱉어낸 것입니다.

#### 📊 [이해를 돕는 SQL 논리적 실행 순서]

```text
1. FROM     : 어떤 테이블에서 데이터를 가져올 것인가?
2. WHERE    : (그룹화 전) 조건에 맞지 않는 '행(Row)'을 걸러낸다.
----------------------------------------------------------------
3. GROUP BY : 데이터를 특정 컬럼 기준으로 그룹화한다.
4. HAVING   : (그룹화 후) 조건에 맞지 않는 '그룹(Group)'을 걸러낸다. 🌟 (여기가 포인트!)
----------------------------------------------------------------
5. SELECT   : 최종적으로 출력할 컬럼을 선택한다.
6. ORDER BY : 출력 결과를 정렬한다.

```

---

### 💡 해결 방법: `HAVING` 절 사용하기

그룹화(`GROUP BY`)된 이후의 결과값(예: 평균값)을 기준으로 필터링을 하려면 **`HAVING` 절**을 사용해야 합니다.

작성하신 코드에서 `WHERE`를 `HAVING`으로 바꾸고, 위치를 `GROUP BY` 뒤로 옮기면 완벽하게 동작합니다.

#### 1. 첫 번째 솔루션: 질문자님의 코드 수정본 (MySQL / Oracle 공통)

```sql
WITH FI AS (
    SELECT
        ID,
        FISH_TYPE,
        CASE
            WHEN LENGTH IS NULL THEN 10
            ELSE LENGTH
        END AS SIZE,
        TIME
    FROM FISH_INFO
)
SELECT
    COUNT(ID) AS FISH_COUNT,
    MAX(SIZE) AS MAX_LENGTH,
    FISH_TYPE
FROM FI
GROUP BY FISH_TYPE
HAVING AVG(SIZE) >= 33      -- ✅ WHERE 대신 HAVING을 GROUP BY 뒤에 사용!
ORDER BY FISH_TYPE ASC;

```

---

### 🚀 대안적 풀이: 더 간결하고 효율적인 접근법

코딩 테스트에서는 제한된 시간 안에 빠르게 쿼리를 작성하는 것도 중요합니다. `WITH` 절과 `CASE` 문 없이, 데이터베이스 내장 함수를 활용하여 하나의 `SELECT` 문으로 끝내는 방법도 소개해 드립니다.

#### 2. 두 번째 솔루션: `IFNULL` / `COALESCE` 활용 (MySQL)

MySQL에서는 `IFNULL(컬럼, 대체값)` 함수를 사용하면 `CASE` 문을 아주 짧게 줄일 수 있습니다. (표준 SQL인 `COALESCE(LENGTH, 10)`을 사용해도 똑같이 동작하며 Oracle에서도 호환됩니다.)

```sql
SELECT
    COUNT(ID) AS FISH_COUNT,
    MAX(IFNULL(LENGTH, 10)) AS MAX_LENGTH, -- NULL이면 10으로, 아니면 LENGTH 반환
    FISH_TYPE
FROM FISH_INFO
GROUP BY FISH_TYPE
HAVING AVG(IFNULL(LENGTH, 10)) >= 33     -- 그룹의 평균을 구할 때도 NULL을 10으로 취급
ORDER BY FISH_TYPE ASC;

```

* **해설**: 임시 테이블(`WITH FI`)을 만들지 않고 원본 테이블에서 바로 집계합니다. `LENGTH`가 `NULL`인 경우 즉석에서 `10`으로 변환하여 `MAX`와 `AVG`를 구하므로 코드가 훨씬 간결해집니다.

---

# 빈출 되는 핵심 내장 함수 정리

### 1. `IFNULL` vs `COALESCE` 완벽 비교

가장 핵심적인 차이는 **'표준 SQL 여부'**와 **'받을 수 있는 인자(파라미터)의 개수'**입니다.

#### 💡 `IFNULL` (MySQL 전용)

* **특징:** 오직 **두 개**의 인자만 받습니다.
* **동작:** 첫 번째 인자가 `NULL`이면 두 번째 인자를 반환하고, 아니면 첫 번째 인자를 반환합니다.
* **예시:** `IFNULL(LENGTH, 10)` → `LENGTH`가 NULL이면 10, 아니면 `LENGTH`.
* **주의점:** Oracle이나 PostgreSQL 등 다른 RDBMS에서는 사용할 수 없습니다. (Oracle은 `NVL`이라는 자체 함수를 사용합니다.)

#### 🌟 `COALESCE` (표준 SQL)

* **특징:** **여러 개(2개 이상)**의 인자를 받을 수 있습니다. 표준 SQL이므로 MySQL, Oracle, PostgreSQL 등 거의 모든 DB에서 호환됩니다.
* **동작:** 주어진 인자들을 순서대로 평가하여 **처음으로 `NULL`이 아닌 값**을 반환합니다. 모든 인자가 `NULL`이면 `NULL`을 반환합니다.
* **예시:** `COALESCE(COL1, COL2, COL3, '없음')` → `COL1`이 NULL이면 `COL2` 확인, `COL2`도 NULL이면 `COL3` 확인... 이런 식으로 연쇄적인 대체가 가능합니다.

#### 📊 [한눈에 보는 비교 테이블]

| 특징 | `IFNULL()` | `COALESCE()` |
| --- | --- | --- |
| **호환성** | MySQL 전용 (비표준) | 대부분의 RDBMS 지원 (표준 SQL) |
| **인자 개수** | 딱 2개 | 2개 이상 (무제한에 가까움) |
| **활용 예시** | `IFNULL(이름, '무명')` | `COALESCE(휴대폰, 집전화, 회사전화, '연락처없음')` |
| **코딩 테스트 추천도** | ⭐️⭐️⭐️ (MySQL 환경 한정 편함) | ⭐️⭐️⭐️⭐️⭐️ (어느 환경이든 안전함) |

> **👨‍🏫 멘토의 팁:** 코딩 테스트에서는 습관적으로 **`COALESCE`를 사용하는 것을 강력히 추천**합니다. 언어나 DB 환경을 가리지 않고 작동하며, 확장성도 좋기 때문입니다.

---

### 2. 코딩 테스트 빈출 핵심 내장 함수 (MySQL 기준)

SQL 코딩 테스트는 크게 **문자열 조작, 날짜 포맷팅, 순위 매기기** 이 세 가지를 얼마나 잘 다루는지 평가하는 경우가 많습니다.

#### A. 문자열 함수 (String Functions)

데이터의 일부만 추출하거나 합칠 때 자주 사용됩니다.

* **`SUBSTRING(문자열, 시작위치, 길이)`** (또는 `SUBSTR`)
* 문자열의 특정 부분을 잘라냅니다. (주의: SQL에서 인덱스는 1부터 시작합니다.)
* *예시:* `SUBSTRING('2024-05-15', 1, 4)` ➔ `'2024'`


* **`CONCAT(문자열1, 문자열2, ...)`**
* 여러 문자열을 하나로 합칩니다.
* *예시:* `CONCAT(FIRST_NAME, ' ', LAST_NAME)` ➔ `'John Doe'`


* **`REPLACE(문자열, 찾을문자, 바꿀문자)`**
* 특정 문자를 다른 문자로 치환합니다.
* *예시:* `REPLACE('010-1234-5678', '-', '')` ➔ `'01012345678'`



#### B. 날짜 및 시간 함수 (Date Functions)

"YYYY-MM-DD 형식으로 출력하시오"라는 요구사항을 맞추기 위해 **반드시** 알아야 합니다.

* **`DATE_FORMAT(날짜, 포맷)`** (MySQL 전용, Oracle은 `TO_CHAR` 사용)
* 날짜를 원하는 형태의 문자열로 바꿉니다.
* *예시:* `DATE_FORMAT(TIME, '%Y-%m-%d')` ➔ `'2022-03-09'`
* *포맷 기호:* `%Y` (4자리 연도), `%m` (2자리 월), `%d` (2자리 일). (대소문자 구분에 주의하세요!)


* **`DATEDIFF(종료일, 시작일)`**
* 두 날짜 간의 차이(일수)를 계산합니다. "대여 기간이 30일 이상인..." 같은 조건에 쓰입니다.



#### C. 윈도우 함수 (Window Functions) - ⭐️ 고득점의 열쇠

"부서별 급여 1위 직원", "날짜별 누적 가입자 수" 등을 구할 때 필수적입니다. `GROUP BY`와 달리 원본 행을 유지하면서 집계/순위를 계산합니다.

* **`RANK() OVER (PARTITION BY 그룹컬럼 ORDER BY 정렬컬럼)`**
* 순위를 매깁니다. 동점자가 있으면 다음 순위를 건너뜁니다 (예: 1등, 1등, 3등, 4등...).


* **`DENSE_RANK() OVER (...)`**
* 동점자가 있어도 다음 순위를 건너뛰지 않습니다 (예: 1등, 1등, 2등, 3등...).



```text
[ RANK vs DENSE_RANK 동작 비교 다이어그램 ]
점수  | RANK | DENSE_RANK
-------------------------
 90  |  1   |    1
 90  |  1   |    1
 85  |  3   |    2  <-- 차이점 발생!
 80  |  4   |    3

```

---

 */