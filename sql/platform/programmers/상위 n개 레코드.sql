-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/59405
-- 상위 n개 레코드
-- 레벨1


-- ORACLE

SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME ASC FETCH FIRST 1 ROW ONLY;

---

SELECT NAME
FROM ANIMAL_INS
WHERE DATETIME = (SELECT MIN(DATETIME) FROM ANIMAL_INS);

---

SELECT NAME
FROM (
         SELECT NAME
         FROM ANIMAL_INS
         ORDER BY DATETIME ASC
     )
WHERE ROWNUM = 1;


/*
 네, 작성하신 `FETCH FIRST 1 ROW ONLY` 구문은 **ANSI 표준 SQL 문법**으로, Oracle(12c 이상)과 PostgreSQL에서 아주 잘 동작하는 **훌륭한 답안**입니다.

하지만 실무 환경이나 사용하는 데이터베이스 종류(MySQL 등)에 따라 다른 방식을 써야 할 수도 있고, **SQL의 작동 원리를 더 깊게 이해하기 위해** 다른 풀이 방법들도 알아두시면 좋습니다.

가장 대표적인 3가지 대체 방법을 소개해 드립니다.

---

### 1. `LIMIT` 사용 (MySQL, PostgreSQL)

가장 많이 쓰이는 방식입니다. 코딩 테스트에서 MySQL을 선택했다면 이 방식이 표준입니다.

```sql
SELECT NAME
FROM ANIMAL_INS
ORDER BY DATETIME ASC
LIMIT 1;

```

* **설명:** `ORDER BY`로 정렬한 뒤 `LIMIT 1`을 통해 가장 위의 1개 행만 잘라냅니다.
* **장점:** 구문이 매우 짧고 직관적입니다.
* **주의:** Oracle 구버전에서는 동작하지 않습니다.

---

### 2. 서브쿼리와 집계함수 `MIN()` 사용 (모든 DB 공통)

"가장 먼저 들어온"이라는 의미를 **"입소일(DATETIME)이 최소값인"** 데이터로 해석하여 푸는 정석적인 방법입니다.

```sql
SELECT NAME
FROM ANIMAL_INS
WHERE DATETIME = (SELECT MIN(DATETIME) FROM ANIMAL_INS);

```

* **동작 원리:**
1. `(SELECT MIN(DATETIME) FROM ANIMAL_INS)`가 먼저 실행되어 가장 빠른 날짜를 찾습니다.
2. 메인 쿼리에서 그 날짜와 일치하는 행의 이름을 조회합니다.


* **특징:**
* `ORDER BY` 방식과 달리, 만약 **가장 먼저 들어온 동물이 2마리 이상(동시 입장)이라면 2마리 모두 출력**됩니다. (문제에서는 1마리라고 가정했으므로 결과는 같습니다.)
* 가장 범용적인 SQL 문법이라 어떤 DB에서도 다 돌아갑니다.



---

### 3. `ROWNUM` 사용 (Oracle 구버전 호환)

Oracle을 쓰는데 버전이 낮거나, 전통적인 방식을 선호한다면 `ROWNUM`을 씁니다. 여기서 **주의할 점**이 있습니다.

**[잘못된 작성법]**

```sql
-- ⚠️ 틀린 예시: 정렬되기 전에 ROWNUM이 먼저 매겨짐
SELECT NAME
FROM ANIMAL_INS
WHERE ROWNUM = 1
ORDER BY DATETIME;

```

**[올바른 작성법: 인라인 뷰 사용]**

```sql
SELECT NAME
FROM (
    SELECT NAME
    FROM ANIMAL_INS
    ORDER BY DATETIME ASC
)
WHERE ROWNUM = 1;

```

* **설명:** Oracle의 `ROWNUM`은 정렬(`ORDER BY`)하기 전에 번호를 매깁니다. 그래서 반드시 **서브쿼리(인라인 뷰) 안에서 먼저 정렬**을 시킨 뒤, 바깥에서 1번을 뽑아야 합니다.

### 요약 (Tutor's Tip)

* **작성하신 코드:** 표준을 잘 지킨 아주 좋은 코드입니다. (PostgreSQL/Oracle 추천)
* **`LIMIT`:** 코딩 테스트에서 가장 빠르고 간편하게 작성할 수 있습니다. (MySQL 추천)
* **`MIN()`:** "최솟값"이라는 논리적 의미가 명확하며, 동점자 처리가 필요할 때 유용합니다.

상황에 맞춰 편한 방법을 선택하시면 됩니다!
 */