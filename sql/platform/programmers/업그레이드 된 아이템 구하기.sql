-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/273711
-- 업그레이드 된 아이템 구하기
-- 레벨2

--- MySQL

SELECT II.ITEM_ID, II.ITEM_NAME, II.RARITY
FROM ITEM_INFO II
    INNER JOIN ITEM_TREE IT
    ON II.ITEM_ID = IT.ITEM_ID
WHERE IT.PARENT_ITEM_ID IN (
    SELECT ITEM_ID
    FROM ITEM_INFO
    WHERE RARITY = 'RARE'
)
ORDER BY II.ITEM_ID DESC;

---

SELECT
    Child.ITEM_ID,
    Child.ITEM_NAME,
    CHild.RARITY
FROM ITEM_INFO Child
INNER JOIN ITEM_TREE T
    ON Child.ITEM_ID = T.ITEM_ID
INNER JOIN ITEM_INFO Parent
    ON T.PARENT_ITEM_ID = Parent.ITEM_ID
WHERE PARENT.RARITY = 'RARE'
ORDER BY Child.ITEM_ID DESC;

/*
 이 문제는 **"부모 아이템의 조건(희귀도=RARE)을 확인하여, 자식 아이템(업그레이드 된 아이템)을 찾아내는 것"**이 핵심입니다.

데이터베이스 테이블 간의 관계를 이해하면 쉽게 풀 수 있습니다. 논리적인 흐름을 먼저 그림으로 설명해 드릴게요.

### 1. 논리적 흐름 (Logic Flow)

우리가 찾아야 하는 것은 **C(자식 아이템)**입니다. 하지만 조건은 **A(부모 아이템)**에 걸려 있죠.

```mermaid
graph LR
    A[ITEM_INFO<br>부모 아이템 찾기] -- 1. 희귀도가 RARE인 ID 추출 --> B[ITEM_TREE<br>연결 고리 확인]
    B -- 2. 해당 부모를 가진 자식 ID 찾기 --> C[ITEM_INFO<br>자식 정보 출력]
    C -- 3. 결과 출력 --> D[정답]

```

1. **부모 찾기**: `ITEM_INFO`에서 `RARITY`가 'RARE'인 아이템들의 `ITEM_ID`를 먼저 찾습니다.
2. **자식 찾기**: `ITEM_TREE` 테이블을 통해, 위에서 찾은 아이템을 `PARENT_ITEM_ID`로 가지고 있는 `ITEM_ID`(자식)를 찾습니다.
3. **정보 조회**: 찾은 자식 `ITEM_ID`의 상세 정보(이름, 희귀도)를 `ITEM_INFO`에서 다시 조회합니다.

---

### 2. 모범 답안 (SQL Solution)

서브쿼리를 활용하면 가장 직관적으로 풀 수 있습니다.

```sql
SELECT
    I.ITEM_ID,
    I.ITEM_NAME,
    I.RARITY
FROM ITEM_INFO I
INNER JOIN ITEM_TREE T
    ON I.ITEM_ID = T.ITEM_ID
WHERE T.PARENT_ITEM_ID IN (
    SELECT ITEM_ID
    FROM ITEM_INFO
    WHERE RARITY = 'RARE'
)
ORDER BY I.ITEM_ID DESC;

```

---

### 3. 상세 설명 (Tutor's Note)

쿼리를 안쪽(Subquery)부터 바깥쪽으로 해석하면 이해하기 쉽습니다.

#### ① 서브쿼리 부분 (조건에 맞는 부모 찾기)

```sql
(SELECT ITEM_ID FROM ITEM_INFO WHERE RARITY = 'RARE')

```

* `ITEM_INFO` 테이블에서 희귀도가 'RARE'인 아이템들의 ID 목록을 만듭니다. (예: ITEM_A, ITEM_B의 ID)

#### ② 메인 쿼리 - WHERE 절 (연결 고리)

```sql
WHERE T.PARENT_ITEM_ID IN (...)

```

* `ITEM_TREE` 테이블(`T`)을 보면서, 방금 구한 **'RARE 아이템들'을 부모(`PARENT_ITEM_ID`)로 모시고 있는** 행을 찾습니다. 즉, 업그레이드 된 아이템(자식)들만 남기게 됩니다.

#### ③ 메인 쿼리 - SELECT & JOIN (자식 정보 출력)

```sql
FROM ITEM_INFO I
INNER JOIN ITEM_TREE T ON I.ITEM_ID = T.ITEM_ID

```

* 우리가 최종적으로 출력해야 할 것은 '자식 아이템'의 이름과 희귀도입니다.
* `ITEM_TREE`에는 ID만 있으므로, `ITEM_INFO`(`I`)와 조인하여 자식 아이템의 상세 정보를 가져옵니다.

#### ④ 정렬

```sql
ORDER BY I.ITEM_ID DESC;

```

* 문제 요구사항대로 아이템 ID 기준 내림차순 정렬합니다.

---

### 4. 다른 풀이 (INNER JOIN 3번 사용)

서브쿼리가 익숙하지 않다면, 테이블을 3번 연결해서 풀 수도 있습니다. (성능상으로도 아주 좋습니다.)

```sql
SELECT
    Child.ITEM_ID,
    Child.ITEM_NAME,
    Child.RARITY
FROM ITEM_INFO Child
INNER JOIN ITEM_TREE T
    ON Child.ITEM_ID = T.ITEM_ID
INNER JOIN ITEM_INFO Parent
    ON T.PARENT_ITEM_ID = Parent.ITEM_ID
WHERE Parent.RARITY = 'RARE'
ORDER BY Child.ITEM_ID DESC;

```

* **Child**: 우리가 정보를 조회할 자식 아이템 테이블
* **Tree**: 자식과 부모를 이어주는 다리
* **Parent**: 부모의 'RARE' 여부를 확인하기 위한 테이블

두 방법 모두 정답이며, 실무에서도 자주 사용되는 방식들입니다. 이해가 잘 되는 쪽으로 선택해서 학습해 보세요!
 */