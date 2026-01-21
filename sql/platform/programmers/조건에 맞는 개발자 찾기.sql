-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/276034
-- 조건에 맞는 개발자 찾기
-- 레벨2

-- MySQL
SELECT Devs.ID, Devs.EMAIL, Devs.FIRST_NAME, Devs.LAST_NAME
FROM DEVELOPERS Devs
WHERE Devs.SKILL_CODE & (SELECT CODE FROM SKILLCODES WHERE NAME = 'Python')
    OR Devs.SKILL_CODE & (SELECT CODE FROM SKILLCODES WHERE NAME = 'C#')
ORDER BY Devs.ID ASC;

---

SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (
    SELECT SUM(CODE)
    FROM SKILLCODES
    WHERE NAME IN ('Python', 'C#')
)
ORDER BY ID ASC;

/*

 이 문제는 **비트 연산(Bitwise Operation)**을 이해하고 있는지 묻는 전형적인 문제입니다.
일반적인 `=` 비교나 `LIKE` 검색으로는 풀 수 없고, **`&` (비트 논리곱, AND) 연산자**를 사용해야 합니다.

비트 연산이 처음이라면 어렵게 느껴질 수 있으니, 원리부터 차근차근 설명해 드릴게요.

---

### 1. 핵심 원리: 비트 연산자 `&`

문제에서 스킬 코드는 **2의 제곱수(1, 2, 4, 8, 16...)**로 되어 있습니다. 이는 이진수 체계에서 **각 자릿수**를 의미합니다.

* Python: `256` ()
* C#: `1024` ()

어떤 개발자의 `SKILL_CODE`가 `400`이라면, 이 숫자는 의 합입니다.
이 개발자가 **Python(256)**을 가지고 있는지 확인하려면 **AND 연산(`&`)**을 수행하면 됩니다.

* **공식:** `(개발자_스킬코드 & 찾으려는_스킬코드) = 찾으려는_스킬코드`
* 또는 단순히 `(개발자_스킬코드 & 찾으려는_스킬코드) > 0` (결과가 0이 아니면 포함된 것)



---

### 2. 모범 답안 (MySQL, PostgreSQL 기준)

가장 직관적인 방법은 "Python 코드와 AND 연산 결과가 참" **이거나(OR)** "C# 코드와 AND 연산 결과가 참"인 사람을 찾는 것입니다.

```sql
SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (SELECT CODE FROM SKILLCODES WHERE NAME = 'Python')
   OR SKILL_CODE & (SELECT CODE FROM SKILLCODES WHERE NAME = 'C#')
ORDER BY ID ASC;

```

#### 💡 코드 상세 설명

1. **`(SELECT CODE FROM SKILLCODES WHERE NAME = 'Python')`**:
* `SKILLCODES` 테이블에서 'Python'에 해당하는 숫자(예: 256)를 찾아옵니다. 하드코딩(숫자를 직접 입력)하지 않고 서브쿼리를 쓰는 것이 실무적으로 훨씬 안전합니다.


2. **`SKILL_CODE & (...)`**:
* 개발자의 스킬 코드와 Python 코드를 비트 AND 연산합니다.
* 만약 개발자가 Python 스킬이 있다면 결과는 `256`(0이 아님)이 나오고, 없다면 `0`이 나옵니다.
* SQL의 `WHERE` 절은 `0`이 아니면 `TRUE`로 인식합니다.


3. **`OR`**:
* 문제 조건이 "Python **이나** C#"이므로 `OR`로 연결합니다.



---

### 3. 또 다른 방법 (심화: 비트 합집합 활용)

비트 연산의 특성을 이용하면 쿼리를 더 줄일 수도 있습니다. Python과 C#의 코드를 미리 더해서 한 번에 비교하는 방식입니다.

```sql
SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPERS
WHERE SKILL_CODE & (
    SELECT SUM(CODE)
    FROM SKILLCODES
    WHERE NAME IN ('Python', 'C#')
)
ORDER BY ID ASC;

```

* **원리:** Python(256)과 C#(1024)를 더하면 `1280`입니다.
* 개발자의 스킬 코드와 `1280`을 AND 연산(`&`)했을 때, 둘 중 하나라도 가지고 있다면 결과는 0보다 크게 나옵니다.

---

### ⚠️ DB별 주의사항 (Oracle 사용자라면?)

만약 **Oracle** DB를 사용하신다면 `&` 기호 대신 **`BITAND` 함수**를 써야 합니다.

**[Oracle 버전 정답]**

```sql
SELECT ID, EMAIL, FIRST_NAME, LAST_NAME
FROM DEVELOPERS
WHERE BITAND(SKILL_CODE, (SELECT CODE FROM SKILLCODES WHERE NAME = 'Python')) > 0
   OR BITAND(SKILL_CODE, (SELECT CODE FROM SKILLCODES WHERE NAME = 'C#')) > 0
ORDER BY ID ASC;

```

**요약:**
이 문제는 **"두 숫자를 `&` 연산했을 때 0이 아니면 포함된 것이다"**라는 공식만 기억하시면 됩니다!

 */