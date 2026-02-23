-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/273711
-- 물고기_종류_별_대어_찾기
-- 레벨3

--- MYSQL
SELECT FI.ID, FNI.FISH_NAME, FI.LENGTH
FROM FISH_INFO FI
    INNER JOIN FISH_NAME_INFO FNI
    ON FI.FISH_TYPE = FNI.FISH_TYPE
WHERE (FI.FISH_TYPE, FI.LENGTH) IN (
    SELECT FISH_TYPE, MAX(LENGTH)
    FROM FISH_INFO
    GROUP BY FISH_TYPE
)
ORDER BY FI.ID ASC;

---

SELECT ID, FISH_NAME, LENGTH
FROM (
         SELECT
             FI.ID,
             FNI.FISH_NAME,
             FI.LENGTH,
             RANK() OVER (PARTITION BY FI.FISH_TYPE ORDER BY FI.LENGTH DESC) AS RNK
         FROM FISH_INFO FI
                  JOIN FISH_NAME_INFO FNI ON FI.FISH_TYPE = FNI.FISH_TYPE
     ) A
WHERE RNK = 1
ORDER BY ID ASC;


/*

 작성하신 쿼리에서 에러가 발생한 가장 큰 이유는 **테이블 지정 실수**와 **GROUP BY의 동작 원리** 때문입니다.

### ❌ 에러 원인 분석 (1054 Error)

1. **테이블 별칭(Alias) 실수:**
```sql
FROM FISH_NAME_INFO FI  -- 여기서 FI를 '이름 정보' 테이블로 지정했습니다.

```


그런데 `SELECT FI.ID`를 하셨죠? `FISH_NAME_INFO` 테이블에는 `ID`나 `LENGTH` 컬럼이 없습니다. 이 컬럼들은 `FISH_INFO` 테이블에 있습니다. `FROM` 절에 `FISH_INFO`를 쓰셨어야 했습니다.
2. **GROUP BY의 한계:**
설령 테이블을 맞게 고친다 해도, `GROUP BY FISH_TYPE`을 쓰면 결과가 물고기 종류별로 1줄로 압축됩니다. 이때 `SELECT ID`를 하면, **"최대 길이를 가진 물고기의 ID"**가 나오는 게 아니라, 그룹 내의 **임의의 ID**가 나오거나 에러가 발생합니다. (어떤 ID를 표시해야 할지 DB가 알 수 없기 때문입니다.)

---

### ✅ 해결 방법: 서브쿼리 활용 (WHERE IN)

이 문제는 **"물고기 종류별 최대 길이"**를 먼저 구하고, **"그 길이와 종류를 가진 물고기"**를 다시 찾아내는 방식(Tuple Comparison)이 가장 정석입니다.

#### [모범 답안]

```sql
SELECT
    FI.ID,
    FNI.FISH_NAME,
    FI.LENGTH
FROM FISH_INFO FI
JOIN FISH_NAME_INFO FNI
    ON FI.FISH_TYPE = FNI.FISH_TYPE
WHERE (FI.FISH_TYPE, FI.LENGTH) IN (
    -- [1] 종류별로 가장 큰 길이를 먼저 구합니다.
    SELECT FISH_TYPE, MAX(LENGTH)
    FROM FISH_INFO
    GROUP BY FISH_TYPE
)
ORDER BY FI.ID ASC;

```

### 💡 상세 설명

1. **서브쿼리 (`SELECT ... GROUP BY`)**:
* 먼저 `FISH_INFO` 테이블에서 종류(`FISH_TYPE`)별로 가장 큰 길이(`MAX(LENGTH)`)가 무엇인지 명단(쌍)을 만듭니다.
* 예: `(0, 60)`, `(1, 73)`, `(2, 73)` ...


2. **`WHERE (A, B) IN (...)`**:
* 메인 테이블(`FISH_INFO`)의 데이터 중, 위에서 만든 **(종류, 최대길이) 쌍과 정확히 일치하는 행**만 뽑아냅니다.
* 이렇게 해야 최대 길이를 가진 물고기의 **진짜 ID**를 가져올 수 있습니다.


3. **`JOIN`**:
* 마지막으로 이름을 가져오기 위해 `FISH_NAME_INFO`와 조인합니다.



---

### 💡 다른 방법 (윈도우 함수 사용 - MySQL 8.0+)

만약 윈도우 함수(`RANK`)를 사용할 수 있다면 아래와 같이 풀 수도 있습니다. 이 방식은 **"동일한 최대 길이가 여러 마리일 때"** 처리하기 좋습니다.

```sql
SELECT ID, FISH_NAME, LENGTH
FROM (
    SELECT
        FI.ID,
        FNI.FISH_NAME,
        FI.LENGTH,
        RANK() OVER (PARTITION BY FI.FISH_TYPE ORDER BY FI.LENGTH DESC) AS RNK
    FROM FISH_INFO FI
    JOIN FISH_NAME_INFO FNI ON FI.FISH_TYPE = FNI.FISH_TYPE
) A
WHERE RNK = 1
ORDER BY ID ASC;

```

* 종류별로(`PARTITION BY`) 길이 내림차순 순위(`RANK`)를 매긴 뒤, 1등(`RNK=1`)만 뽑아내는 방식입니다.

두 방법 중 편한 것을 사용하시면 되지만, **서브쿼리 방식(첫 번째 답안)**이 SQLD 시험 등에서는 더 자주 나오는 패턴입니다!

 */