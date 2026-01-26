-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/299305
-- 대장균들의 자식의 수 구하기
-- 레벨3



SELECT P.ID,
    (SELECT COUNT(*)
     FROM ECOLI_DATA C
     WHERE C.PARENT_ID = P.ID) AS CHILD_COUNT
FROM ECOLI_DATA P
ORDER BY P.ID;

---


SELECT
    P.ID,
    COUNT(C.ID) AS CHILD_COUNT
FROM ECOLI_DATA P
         LEFT JOIN ECOLI_DATA C ON P.ID = C.PARENT_ID
GROUP BY P.ID
ORDER BY P.ID ASC;



/*

 이 문제는 **'셀프 조인(Self Join)'** 혹은 **'서브쿼리(Subquery)'**를 통해 해결할 수 있습니다.

같은 테이블 안에서 **"나의 ID"**와 **"다른 행의 PARENT_ID"**를 비교해야 한다는 점이 핵심입니다.

가장 이해하기 쉽고 직관적인 **서브쿼리 방식**과, 실무에서 대량의 데이터를 처리할 때 유리한 **LEFT JOIN 방식** 두 가지를 모두 알려드릴게요.

---

### 1. 모범 답안 (서브쿼리 방식 - 추천 ⭐)

"나(ID)를 부모로 가지고 있는 데이터가 몇 개인지 세어라"라는 로직을 그대로 SQL로 옮긴 방식입니다. 코드가 직관적이라 실수할 확률이 적습니다.

```sql
SELECT
    ID,
    (SELECT COUNT(*)
     FROM ECOLI_DATA
     WHERE PARENT_ID = A.ID) AS CHILD_COUNT
FROM ECOLI_DATA A
ORDER BY ID ASC;

```

#### 💡 상세 설명

1. **`FROM ECOLI_DATA A`**: 전체 대장균 목록을 가져옵니다. (별칭 A)
2. **`SELECT ID`**: 각 대장균의 ID를 출력합니다.
3. **`(SELECT COUNT(*) ... WHERE PARENT_ID = A.ID)`**:
* 현재 조회 중인 대장균(A)의 `ID`를 `PARENT_ID`로 가지고 있는 자식들이 몇 마리인지 셉니다.
* 만약 자식이 없다면 `COUNT` 함수는 자동으로 `0`을 반환하므로, 문제의 조건(자식이 없으면 0 출력)을 별도 처리 없이 만족합니다.



---

### 2. 다른 풀이 (LEFT JOIN 방식 - 실무형)

테이블을 두 개로 복제하듯 연결하여 집계하는 방식입니다.

```sql
SELECT
    P.ID,
    COUNT(C.ID) AS CHILD_COUNT
FROM ECOLI_DATA P
LEFT JOIN ECOLI_DATA C ON P.ID = C.PARENT_ID
GROUP BY P.ID
ORDER BY P.ID ASC;

```

#### 💡 상세 설명

1. **`FROM ECOLI_DATA P` (부모 테이블)**: 기준이 되는 전체 대장균입니다.
2. **`LEFT JOIN ECOLI_DATA C` (자식 테이블)**:
* `P.ID = C.PARENT_ID` 조건으로 연결합니다.
* **중요:** `INNER JOIN`이 아닌 **`LEFT JOIN`**을 써야 합니다. `INNER JOIN`을 쓰면 자식이 없는 대장균(ID 3, 5, 6 등)은 결과에서 아예 사라지기 때문입니다.


3. **`COUNT(C.ID)`**:
* 자식 테이블(`C`)의 ID 개수를 셉니다.
* 자식이 없는 경우 `C.ID`는 `NULL`이 되며, `COUNT` 함수는 `NULL`을 세지 않으므로 자연스럽게 `0`이 됩니다.
* *(주의: `COUNT(*)`를 쓰면 자식이 없어도 행이 1개 존재한다고 판단하여 1로 출력될 수 있으니 반드시 컬럼명을 지정해야 합니다.)*



### 요약

두 방식 모두 정답입니다!

* **서브쿼리 방식:** 논리가 직관적이고 코드가 짧아서 코딩 테스트용으로 추천합니다.
* **LEFT JOIN 방식:** 데이터 구조를 한눈에 파악하거나 다른 집계(예: 자식들의 평균 크기 등)를 같이 해야 할 때 확장성이 좋습니다.

 */