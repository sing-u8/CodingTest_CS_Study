-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/301651
-- 멸종 위기의 대장균 찾기
-- 레벨5

--- MySQL

WITH RECURSIVE ED_GEN_CTE AS (
    SELECT ID, PARENT_ID, 1 AS GENERATION
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NULL

    UNION ALL

    SELECT CHILD.ID, CHILD.PARENT_ID, PARENT.GENERATION + 1
    FROM ECOLI_DATA CHILD
             INNER JOIN ED_GEN_CTE PARENT
                        ON PARENT.ID = CHILD.PARENT_ID
)

SELECT COUNT(*) AS COUNT, GENERATION
FROM ED_GEN_CTE
WHERE ID NOT IN (
    SELECT DISTINCT PARENT_ID
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NOT NULL
    )
GROUP BY GENERATION
ORDER BY GENERATION ASC;

/*

 이 문제는 **"각 개체가 몇 세대인지(Recursive CTE)"** 구하는 로직과 **"자식이 없는지(Subquery or Join)"** 확인하는 로직 두 가지를 합쳐야 하는 심화 문제입니다.

방금 배우신 **재귀 쿼리(`WITH RECURSIVE`)**를 활용할 수 있는 가장 좋은 예제입니다.

### 1. 모범 답안 (Recursive CTE + NOT IN)

가장 직관적인 방법은 **"세대 정보를 다 구한 뒤, 부모 명단에 없는 애들만 남기는 것"**입니다.

```sql
WITH RECURSIVE GEN_DATA AS (
    -- [1] 1세대 찾기 (Anchor)
    SELECT ID, PARENT_ID, 1 AS GENERATION
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NULL

    UNION ALL

    -- [2] 다음 세대 찾기 (Recursive)
    SELECT C.ID, C.PARENT_ID, P.GENERATION + 1
    FROM ECOLI_DATA C
    INNER JOIN GEN_DATA P ON C.PARENT_ID = P.ID
)

-- [3] 메인 쿼리: 자식이 없는 개체만 골라서 세대별로 세기
SELECT COUNT(*) AS COUNT, GENERATION
FROM GEN_DATA
WHERE ID NOT IN (
    -- 전체 데이터에서 '부모' 역할을 하고 있는 ID 목록을 뽑음
    SELECT DISTINCT PARENT_ID
    FROM ECOLI_DATA
    WHERE PARENT_ID IS NOT NULL
)
GROUP BY GENERATION
ORDER BY GENERATION ASC;

```

---

### 2. 상세 설명 (Step-by-Step)

#### ① 세대 구하기 (`WITH RECURSIVE`)

* 앞서 배운 것처럼 1세대(부모 없음)부터 시작해서 자식들을 찾아가며 `GENERATION + 1`을 해줍니다.
* 이 CTE가 실행되면 모든 대장균의 ID와 세대 정보가 담긴 `GEN_DATA` 테이블이 만들어집니다.

#### ② 자식이 없는 개체 찾기 (`WHERE ID NOT IN ...`)

* **"자식이 없다"**는 말은 **"누군가의 부모가 되지 못했다"**는 뜻입니다.
* `ECOLI_DATA` 테이블의 `PARENT_ID` 컬럼에는 "부모들의 ID"가 적혀 있습니다.
* 따라서 `PARENT_ID` 목록에 **내 ID가 없다면(`NOT IN`)** 나는 자식이 없는 것입니다.
* *(주의: `NOT IN` 서브쿼리 안에는 `NULL`이 있으면 안 되므로 `WHERE PARENT_ID IS NOT NULL`을 꼭 붙여줘야 합니다.)*



#### ③ 그룹핑 및 정렬

* `GROUP BY GENERATION`: 세대별로 묶습니다.
* `COUNT(*)`: 개수를 셉니다.
* `ORDER BY`: 세대 순으로 정렬합니다.

---

### 💡 다른 방법 (`LEFT JOIN` 활용)

`NOT IN` 대신 **`LEFT JOIN`**을 써서 자식이 없는 것을 확인할 수도 있습니다. 성능상으로는 이 방법이 조금 더 유리할 수 있습니다.

```sql
/* CTE 부분은 위와 동일 */
...
SELECT COUNT(G.ID) AS COUNT, G.GENERATION
FROM GEN_DATA G
LEFT JOIN ECOLI_DATA Child
    ON G.ID = Child.PARENT_ID   -- 나(G)를 부모로 가진 자식(Child)을 찾음
WHERE Child.ID IS NULL          -- 연결된 자식이 없는 경우만 남김
GROUP BY G.GENERATION
ORDER BY G.GENERATION ASC;

```

두 방법 모두 훌륭한 정답입니다! 논리 흐름이 더 편한 쪽으로 선택해 보세요.

 */