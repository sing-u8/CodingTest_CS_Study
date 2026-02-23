-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/301650
-- 특정 세대의 대장균 찾기
-- 레벨4

--- MySQL

WITH RECURSIVE GENERATION_CTE AS (
    SELECT ID, PARENT_ID, 1 AS GEN
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NULL

    UNION ALL

    SELECT CHILD.ID, CHILD.PARENT_ID, PARENT.GEN + 1
    FROM ECOLI_DATA CHILD
             INNER JOIN GENERATION_CTE PARENT
                        ON CHILD.PARENT_ID = PARENT.ID
)

SELECT ID
FROM GENERATION_CTE
WHERE GEN = 3
ORDER BY ID ASC;

/*

 **재귀 쿼리(Recursive Query)**는 SQL에서 **"자기 자신을 계속 참조하면서 반복적으로 데이터를 찾아가는 문법"**입니다.

프로그래밍 언어의 `for` 문이나 `while` 문 같은 **반복문**을 SQL 안에서 구현한다고 생각하시면 가장 이해하기 쉽습니다. 주로 **계층 구조(조직도, 카테고리, 대댓글)**나 **연속된 숫자/날짜 생성**에 사용됩니다.

---

### 1. 기본 문법 구조 (Anatomy)

재귀 쿼리는 `WITH RECURSIVE`라는 구문을 사용하며, 크게 **세 부분**으로 구성됩니다.

```sql
WITH RECURSIVE 테이블명_CTE AS (

    -- [1] 앵커 멤버 (Anchor Member)
    -- : 반복의 시작점(초기값). 딱 한 번만 실행됩니다.
    SELECT ...
    FROM ...
    WHERE ... (시작 조건)

    UNION ALL  -- 위 결과와 아래 결과를 합침

    -- [2] 재귀 멤버 (Recursive Member)
    -- : 앵커 멤버(또는 이전 단계의 결과)를 참조하여 반복 실행되는 부분
    SELECT ...
    FROM 원본테이블
    INNER JOIN 테이블명_CTE  -- 자기 자신(CTE)을 조인!
        ON ... (연결 고리)
    WHERE ... (종료 조건)
)

-- [3] 메인 쿼리
SELECT * FROM 테이블명_CTE;

```

---

### 2. 동작 원리 (Step-by-Step)

DB 엔진은 이 쿼리를 다음과 같은 순서로 처리합니다.

1. **앵커 멤버 실행 (Step 0):**
* 가장 먼저 [1]번 쿼리를 실행합니다. 이 결과가 **첫 번째 결과 집합(R0)**이 됩니다.
* (예: 1세대 대장균을 찾음)


2. **재귀 멤버 실행 (Step 1):**
* 방금 구한 **R0**를 [2]번 쿼리의 `테이블명_CTE` 자리에 넣고 실행합니다.
* 이 결과가 **두 번째 결과 집합(R1)**이 됩니다.
* (예: 1세대의 자식인 2세대를 찾음)


3. **재귀 멤버 반복 (Step 2, 3...):**
* 방금 구한 **R1**을 다시 [2]번 쿼리에 넣고 실행 -> **R2** 생성.
* 이 과정을 계속 반복합니다.


4. **종료 (Stop):**
* 더 이상 조인되는 데이터가 없어서 결과가 **0건(Empty)**이 나오면 반복을 멈춥니다.
* 지금까지 모은 모든 결과(R0 + R1 + R2 + ...)를 합쳐서 최종 결과로 반환합니다.



---

### 3. 쉬운 예제: 1부터 5까지 숫자 만들기

가장 간단한 예제로 문법을 익혀보겠습니다.

```sql
WITH RECURSIVE NumberSequence AS (
    -- [1] 시작점: 1
    SELECT 1 AS NUM

    UNION ALL

    -- [2] 반복: 기존 값에 +1
    SELECT NUM + 1
    FROM NumberSequence
    WHERE NUM < 5  -- [3] 종료 조건: 5보다 작을 때까지만 (즉, 5가 되면 멈춤)
)
SELECT * FROM NumberSequence;

```

**[실행 과정]**

1. **Anchor:** `1` 생성. (결과: `{1}`)
2. **Loop 1:** `{1}`을 가져와서 `1 + 1 = 2` 생성. (조건 `1 < 5` 만족)
3. **Loop 2:** `{2}`를 가져와서 `2 + 1 = 3` 생성.
4. **Loop 3:** `{3}`을 가져와서 `3 + 1 = 4` 생성.
5. **Loop 4:** `{4}`를 가져와서 `4 + 1 = 5` 생성.
6. **Loop 5:** `{5}`를 가져와서 `5 + 1 = 6`? -> **`WHERE 5 < 5` 거짓(False)**. 생성 안 함. -> **종료!**

---

### 4. 실무 예제: 조직도 (계층 구조) 풀기

회사 조직도에서 **"사장님부터 말단 사원까지의 계보"**를 뽑는 상황입니다.

* `EMPLOYEES` 테이블: `ID`, `NAME`, `MANAGER_ID`

```sql
WITH RECURSIVE OrgChart AS (
    -- [1] 앵커: 사장님 찾기 (Manager가 없는 사람)
    SELECT ID, NAME, MANAGER_ID, 1 AS LEVEL
    FROM EMPLOYEES
    WHERE MANAGER_ID IS NULL

    UNION ALL

    -- [2] 재귀: 상사(Parent)를 통해 부하직원(Child) 찾기
    SELECT E.ID, E.NAME, E.MANAGER_ID, O.LEVEL + 1
    FROM EMPLOYEES E
    INNER JOIN OrgChart O      -- 방금 찾은 상사들(OrgChart)과 조인
        ON E.MANAGER_ID = O.ID -- 내 매니저 ID가 상사의 ID인 경우
)
SELECT * FROM OrgChart ORDER BY LEVEL, ID;

```

---

### 💡 튜터의 주의사항 (Tutor's Note)

1. **`UNION ALL` 필수:**
* 대부분의 DB에서 재귀 쿼리에는 `UNION` 대신 `UNION ALL`을 써야 합니다. (중복 제거 비용을 없애고, 구조상 데이터를 계속 쌓아가야 하기 때문입니다.)


2. **종료 조건 필수:**
* 숫자 예제에서의 `WHERE NUM < 5`처럼 멈추는 조건이 없으면 **무한 루프(Infinite Loop)**에 빠질 수 있습니다. (DB가 알아서 강제 종료시키기도 하지만 조심해야 합니다.)


3. **성능:**
* 데이터 깊이(Depth)가 너무 깊으면 성능이 느려질 수 있습니다. 하지만 조직도(깊이 10~20)나 대장균 세대 같은 일반적인 계층 구조에서는 아주 효율적입니다.


### 재귀 SELECT 문 순서와 타입 맞추기

재귀 쿼리의 핵심인 `UNION ALL`은 **"위쪽 결과(앵커)와 아래쪽 결과(재귀)를 하나의 테이블로 합치는 연산"**이기 때문에, 물리적인 구조가 다르면 합칠 수가 없습니다.

다음 **3가지**가 반드시 맞아야 합니다.

### 1. 컬럼의 개수 (Column Count)

앵커에서 3개의 컬럼을 뽑았다면, 재귀 부분에서도 반드시 3개를 뽑아야 합니다.

```sql
-- [X] 틀린 예시: 개수가 안 맞음
SELECT ID, NAME, 1 AS LEVEL ...       -- (3개)
UNION ALL
SELECT ID, NAME ...                   -- (2개) -> 에러 발생!

```

### 2. 데이터 타입 (Data Type)

같은 위치에 있는 컬럼끼리는 데이터 타입이 호환되어야 합니다.

* 첫 번째가 숫자면, 아래도 숫자여야 합니다.
* 첫 번째가 날짜면, 아래도 날짜여야 합니다.

```sql
-- [X] 틀린 예시: 타입 불일치
SELECT ID, NAME ...                   -- (숫자, 문자)
UNION ALL
SELECT NAME, ID ...                   -- (문자, 숫자) -> 에러 발생!

```

### 3. 컬럼의 순서 (Order)

이름이 달라도 순서대로 매칭됩니다. 즉, **순서가 의미를 결정**합니다.
만약 순서를 섞어버리면, ID 컬럼에 이름이 들어가거나 하는 대참사가 일어납니다.

---

### 🚨 튜터의 초특급 주의사항 (심화 꿀팁)

재귀 쿼리를 짜다 보면 **"문자열 길이"** 때문에 에러가 자주 납니다. 이 부분은 실무자들도 자주 실수하는 부분이니 꼭 알아두세요!

**상황:** 경로(Path)를 만들 때 (`A -> B -> C`)

```sql
WITH RECURSIVE PathCTE AS (
    -- [1] 앵커
    SELECT 'A' AS PATH  -- DB는 이걸 보고 '아, PATH는 문자 1글자(CHAR(1))구나'라고 확정해버림
    ...
    UNION ALL
    -- [2] 재귀
    SELECT CONCAT(PATH, ' -> ', ID) -- 여기선 글자가 계속 늘어남 ('A -> B'...)
    ...
)

```

**문제점:**
앵커 멤버에서 `'A'`만 보고 데이터 타입을 **`VARCHAR(1)`**로 고정해버리는 DB들이 있습니다. 그런데 재귀 부분에서 글자가 길어지면 **"공간이 부족하다"**며 에러를 내거나 뒷부분을 잘라버립니다.

**해결책:**
앵커 멤버에서 미리 넉넉하게 **캐스팅(CAST)**을 해줘야 합니다.

```sql
-- [O] 올바른 예시
SELECT CAST('A' AS VARCHAR(100)) AS PATH ... -- 미리 100글자 자리 확보!

```

### 요약

* **개수, 타입, 순서**가 무조건 일치해야 합니다.
* 최종 결과의 **컬럼 이름(Alias)**은 **맨 위(앵커 멤버)**에 적은 이름으로 결정됩니다.


 */