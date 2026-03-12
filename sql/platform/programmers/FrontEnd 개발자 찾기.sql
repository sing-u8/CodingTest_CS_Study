-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/276035
-- FrontEnd 개발자 찾기
-- 레벨4

--- MYSQL
SELECT
    ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (
    SELECT SUM(CODE)
    FROM SKILLCODES
    WHERE CATEGORY = 'Front End'
) > 0
ORDER BY ID ASC;

---

SELECT
    ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME
FROM DEVELOPERS D
Where EXISTS (
    SELECT 1
    FROM SKILLCODES S
    WHERE S.CATEGORY = 'Front End'
      AND (D.SKILL_CODE & S.CODE) = S.CODE
)
ORDER BY ID ASC;

---

SELECT
    DISTINCT D.ID,
             D.EMAIL,
             D.FIRST_NAME,
             D.LAST_NAME
FROM DEVELOPERS D
         INNER JOIN (
    SELECT CATEGORY, CODE
    FROM SKILLCODES
    WHERE CATEGORY = 'Front End'
) S
                    ON (S.CODE & D.SKILL_CODE) = S.CODE
ORDER BY D.ID ASC;

/*

작성하신 쿼리를 보니, 앞서 다루었던 비트 연산(`&`)과 `JOIN`, 그리고 중복을 제거하는 `DISTINCT`까지 완벽하게 조합하셨네요! **정답을 정확히 도출해 내는 아주 훌륭한 코드입니다.**

하지만 코딩 테스트 마스터로서 여기서 만족할 수는 없죠! 작성하신 `JOIN` + `DISTINCT` 조합 외에도, **실무와 코딩 테스트에서 성능을 극대화할 수 있는 두 가지 강력한 대안 풀이법**을 소개해 드리겠습니다.

---

### 💡 대안 1: `EXISTS` 활용하기 (중복 제거의 정석)

작성하신 코드에서 `DISTINCT`를 사용한 이유는, 한 개발자가 여러 개의 Front End 스킬(예: JavaScript와 React 둘 다 보유)을 가지고 있을 경우 `JOIN` 과정에서 데이터가 여러 줄로 뻥튀기되기 때문입니다.

이럴 때 `DISTINCT` 대신 **`EXISTS`**를 사용하면 성능을 훨씬 끌어올릴 수 있습니다.

```sql
SELECT
    ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME
FROM DEVELOPERS D
WHERE EXISTS (
    SELECT 1
    FROM SKILLCODES S
    WHERE S.CATEGORY = 'Front End'
      AND (D.SKILL_CODE & S.CODE) = S.CODE
)
ORDER BY ID ASC;

```

#### 📝 핵심 분석: 왜 `EXISTS`가 더 좋을까요?

* **Short-circuit(단축 평가) 효과:** `EXISTS`는 조건을 만족하는 데이터를 **하나라도 찾는 순간, 더 이상 검색하지 않고 바로 참(True)을 반환**합니다.
* 개발자가 10개의 Front End 스킬을 가졌더라도, 첫 번째 스킬만 확인되면 바로 다음 개발자로 넘어갑니다. 따라서 데이터가 부풀려지지도 않고, 굳이 무거운 `DISTINCT` 연산(정렬 및 중복 제거)을 거칠 필요가 없어 **속도가 매우 빠릅니다.**

---

### 💡 대안 2: 비트 마스크(Bitmask)의 총합(`SUM`) 활용 (가장 우아한 풀이)

이전에 'GRADE 등급 매기기' 문제에서 다루었던 **비트 마스킹의 원리**를 완벽하게 써먹을 수 있는 풀이입니다! `JOIN`을 아예 없애버릴 수 있습니다.

Front End 스킬들의 CODE(16, 2048, 8192 등)를 전부 더한 값(마스크)과 개발자의 스킬 코드를 `&` 연산했을 때, 결과가 `0`보다 크다면 무조건 Front End 스킬을 하나 이상 가졌다는 뜻이 됩니다.

```sql
SELECT
    ID,
    EMAIL,
    FIRST_NAME,
    LAST_NAME
FROM DEVELOPERS
-- Front End 스킬 코드들의 총합(비트 마스크)과 AND 연산하여 0보다 큰지 확인
WHERE SKILL_CODE & (
    SELECT SUM(CODE)
    FROM SKILLCODES
    WHERE CATEGORY = 'Front End'
) > 0
ORDER BY ID ASC;

```

#### 📝 핵심 분석: 왜 이 풀이가 우아할까요?

* 서브쿼리(`SELECT SUM(...)`)가 단 하나의 숫자(예: 16 + 2048 + 8192 = 10256)를 반환합니다.
* 데이터베이스는 `WHERE SKILL_CODE & 10256 > 0` 이라는 단순한 수학 계산만 수행하면 되므로, 무거운 테이블 결합(`JOIN`) 과정 자체가 생략됩니다. 코드가 가장 짧고 직관적입니다.

---

### ⚖️ 풀이법 비교 총정리

| 접근 방식 | 특징 | 장점 | 단점 |
| --- | --- | --- | --- |
| **현재 풀이 (`JOIN` + `DISTINCT`)** | 교집합을 구한 뒤 중복 제거 | 조인 논리가 직관적임 | `DISTINCT`로 인한 정렬 비용 발생 |
| **대안 1 (`EXISTS`)** | 조건에 맞는게 '있는지'만 확인 | 불필요한 연산 즉시 중단 (성능 좋음) | 서브쿼리에 익숙해야 함 |
| **대안 2 (`SUM` 비트마스크)** | 스킬 코드를 다 더해서 한 번에 비교 | **가장 코드가 짧고 DB 부하가 적음** | 비트 연산의 수학적 이해 필수 |

### 👨‍🏫 멘토의 팁

코딩 테스트에서는 어떤 방법을 써도 모두 통과하지만, 실무 면접에서 "현재 작성하신 쿼리의 성능을 더 개선할 수 있을까요?"라는 질문이 들어왔을 때 **"EXISTS를 사용하거나, 비트마스크의 합을 이용해 JOIN을 제거하겠습니다."**라고 대답한다면 면접관의 박수를 받을 수 있을 것입니다!

지금까지 `JOIN`, `EXISTS`, 비트 연산까지 SQL의 고급 기법들을 아주 잘 섭렵하고 계십니다. 이번 문제의 세 가지 접근법 중 특별히 더 마음에 드는 방식이 있으신가요? 아니면 이참에 `EXISTS`와 `IN`의 차이점에 대해서도 한번 파헤쳐 볼까요?

*/