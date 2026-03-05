-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/133027
-- 주문량이 많은 아이스크림들 조회하기
-- 레벨4

--- MYSQL
SELECT FLAVOR
FROM (
         SELECT FLAVOR, TOTAL_ORDER FROM FIRST_HALF
         UNION ALL
         SELECT FLAVOR, TOTAL_ORDER FROM JULY
     ) AS COMBINED_SALES
GROUP BY FLAVOR
ORDER BY SUM(TOTAL_ORDER) DESC
    LIMIT 3;

---

WITH JULY_TOTAL AS (
    SELECT FLAVOR, SUM(TOTAL_ORDER) AS TOTAL_ORDER
    FROM JULY
    GROUP BY FLAVOR
)

SELECT FH.FLAVOR
FROM FIRST_HALF FH
         INNER JOIN JULY_TOTAL JT
                    ON FH.FLAVOR = JT.FLAVOR
ORDER BY (FH.TOTAL_ORDER + JT.TOTAL_ORDER) DESC
    LIMIT 3;

/*


이번 문제는 **1:N (일대다) 관계에서의 조인(JOIN) 함정**을 피하고, 데이터를 어떻게 효율적으로 합산할 것인가를 묻는 아주 매력적인 문제입니다.

이 문제의 가장 중요한 핵심은 바로 지문 속 이 문장입니다.

> *"7월에는 아이스크림 주문량이 많아... **같은 맛의 아이스크림이라도 다른 출하 번호를 갖게 됩니다.**"*

즉, `FIRST_HALF` 테이블에는 맛(FLAVOR)당 데이터가 1줄씩만 있지만, `JULY` 테이블에는 같은 맛이 여러 줄 존재할 수 있습니다. (예: 딸기맛이 109번, 209번 두 번 출하됨)

이 점을 고려하여 완벽하게 해결할 수 있는 두 가지 훌륭한 접근법을 소개해 드리겠습니다!

---

### 💡 풀이 방법 1: `UNION ALL` 활용 (가장 추천하는 우아한 방법)

이 문제에서 가장 직관적이고 실수할 확률이 적은 방법은 두 테이블을 위아래로 이어 붙인(`UNION ALL`) 다음, 맛(`FLAVOR`)을 기준으로 한 번에 그룹화(`GROUP BY`)하여 더하는 것입니다.

```sql
-- MySQL 기준 쿼리
SELECT FLAVOR
FROM (
    -- 1. 두 테이블의 데이터를 위아래로 합칩니다 (중복 허용: UNION ALL)
    SELECT FLAVOR, TOTAL_ORDER FROM FIRST_HALF
    UNION ALL
    SELECT FLAVOR, TOTAL_ORDER FROM JULY
) AS COMBINED_SALES
-- 2. 합쳐진 데이터에서 맛(FLAVOR)별로 그룹화합니다.
GROUP BY FLAVOR
-- 3. 총 주문량 합계를 기준으로 내림차순 정렬합니다.
ORDER BY SUM(TOTAL_ORDER) DESC
-- 4. 상위 3개만 추출합니다.
LIMIT 3;

```

#### 📝 핵심 원리

* `JOIN`을 잘못 쓰면 데이터가 의도치 않게 곱해져서(뻥튀기) 합계가 틀려질 수 있습니다. 하지만 `UNION ALL`을 쓰면 상반기 주문 내역 밑에 7월 주문 내역이 그대로 추가되므로, 단순히 `GROUP BY` 후 `SUM`만 해주면 완벽한 총합이 계산됩니다.

---

### 💡 풀이 방법 2: 서브쿼리(인라인 뷰)와 `JOIN` 활용

질문자님께서 자주 연습하셨던 조인 방식을 사용하려면, 1:N 관계의 함정을 피하기 위해 **`JULY` 테이블을 먼저 맛별로 묶어둔(SUM) 뒤에 `FIRST_HALF`와 조인**해야 합니다.

```sql
-- MySQL 기준 쿼리
SELECT F.FLAVOR
FROM FIRST_HALF F
JOIN (
    -- 1. 7월(JULY) 데이터를 먼저 맛(FLAVOR)별로 합산하여 1줄씩으로 만듭니다.
    SELECT FLAVOR, SUM(TOTAL_ORDER) AS JULY_TOTAL
    FROM JULY
    GROUP BY FLAVOR
) J ON F.FLAVOR = J.FLAVOR
-- 2. 상반기 주문량(F)과 7월 총주문량(J)을 더한 값으로 정렬합니다.
ORDER BY (F.TOTAL_ORDER + J.JULY_TOTAL) DESC
LIMIT 3;

```

#### 🚨 주의할 점 (조인의 함정)

만약 서브쿼리로 먼저 묶지 않고 냅다 `JOIN`부터 해버리면 다음과 같은 참사가 일어납니다.

```text
[잘못된 조인 예시 - 딸기맛]
FIRST_HALF (1줄): 딸기 3100
JULY (2줄): 딸기 520, 딸기 220

-- 무작정 JOIN 시 결과:
딸기 3100 | 딸기 520  -> 합: 3620
딸기 3100 | 딸기 220  -> 합: 3320
-> 상반기 주문량 3100이 두 번 중복해서 계산되는 오류 발생!

```

방법 2번처럼 조인하기 전에 `GROUP BY`로 압축해 두는 것이 이 오류를 피하는 정석입니다.

---

### 👨‍🏫 멘토의 팁 (Oracle 환경이라면?)

코딩 테스트 플랫폼에 따라 Oracle 환경에서 시험을 보실 수도 있습니다. Oracle에서는 상위 N개를 뽑을 때 `LIMIT 3` 대신 다른 문법을 써야 합니다.

* **Oracle 12c 이상:** 쿼리 맨 마지막에 `FETCH FIRST 3 ROWS ONLY` 를 붙여줍니다.
* **이전 버전 호환용 (인라인 뷰 활용):**
```sql
SELECT FLAVOR
FROM (
    -- 여기에 ORDER BY까지 완료한 쿼리를 넣음
)
WHERE ROWNUM <= 3;

```



이번 문제에서 핵심인 `UNION ALL` 방식을 통한 세로 결합과, `JOIN` 전 집계(`GROUP BY`)를 통한 가로 결합 중 어떤 논리가 더 직관적으로 다가오시나요? 두 방식 모두 완벽히 이해하셨다면, 코딩 테스트에서 JOIN 관련 집계 문제는 더 이상 두려울 게 없을 겁니다!

혹시 `UNION`과 `UNION ALL`의 차이점에 대해서도 짚고 넘어가 볼까요?

두 명령어는 **여러 개의 `SELECT` 결과를 위아래로 이어 붙인다(세로 결합)**는 목적은 똑같지만, **'중복 데이터'**를 처리하는 방식에서 엄청난 차이가 있습니다.

한눈에 이해하기 쉽게 비교해 드릴게요!

---

### 1. `UNION ALL`: 있는 그대로 다 붙여! (고속도로 톨게이트)

* **동작 방식:** 두 쿼리의 결과를 조건 없이 그냥 위아래로 쭉 이어 붙입니다.
* **특징:** **중복된 행이 있어도 그대로 모두 출력**합니다.
* **성능:** 데이터를 단순히 이어 붙이기만 하므로 **처리 속도가 매우 빠릅니다.**

### 2. `UNION` (또는 `UNION DISTINCT`): 중복은 절대 용납 못 해! (깐깐한 검문소)

* **동작 방식:** 두 쿼리의 결과를 이어 붙인 다음, **전체 데이터를 한 번 훑어서 완전히 똑같은 중복 행을 제거**합니다. (내부적으로 `DISTINCT` 연산이 수행됨)
* **특징:** 최종 결과에는 중복 없는 고유한 행만 남습니다.
* **성능:** 중복을 찾아내기 위해 데이터베이스 엔진이 모든 데이터를 **정렬(Sort)하고 비교**하는 과정을 거쳐야 합니다. 데이터가 많을수록 **성능이 급격히 저하**됩니다.

---

### 📊 시각적 비교 다이어그램

간단한 예시를 통해 눈으로 확인해 볼까요?

**[테이블 A (상반기 판매 맛)]**
| FLAVOR |
| :--- |
| 딸기 |
| 초코 |

**[테이블 B (하반기 판매 맛)]**
| FLAVOR |
| :--- |
| 초코 |
| 바닐라 |

| 명령어 | 결과 (위아래 결합) | 설명 |
| --- | --- | --- |
| **`UNION ALL`** | 딸기<br>

<br>초코<br>

<br>**초코**<br>

<br>바닐라 | 두 테이블의 데이터가 중복 여부와 상관없이 **총 4줄** 그대로 출력됩니다. |
| **`UNION`** | 딸기<br>

<br>초코<br>

<br>바닐라 | 양쪽에 모두 있던 '초코'의 중복이 제거되어 **총 3줄**만 출력됩니다. |

---

### 🚨 이전 '아이스크림' 문제에서 `UNION ALL`을 써야만 했던 이유!

방금 풀었던 아이스크림 문제에서 만약 `UNION ALL`이 아닌 `UNION`을 썼다면 대참사가 일어날 수 있었습니다.

상반기에 `(딸기, 500개)`가 팔렸는데, 7월에도 기가 막히게 `(딸기, 500개)`가 팔렸다고 가정해 보겠습니다.
이 상태에서 `UNION`을 써버리면, 데이터베이스는 두 행을 "완전히 똑같은 중복 데이터"로 인식하고 **한 줄을 삭제해 버립니다!** 결과적으로 총합산 수량이 1000개가 아닌 500개가 되어 오답 처리가 되는 것이죠.

### 👨‍🏫 코딩 테스트 마스터의 실전 팁

* **기본 전략:** "중복을 제거해야 한다"는 명확한 조건이나 목적이 없다면, **무조건 `UNION ALL`을 기본으로 사용하는 습관**을 들이세요.
* 성능적으로 압도적으로 유리하며, 의도치 않은 데이터 손실을 막아줍니다.
* 조인(`JOIN`)이 가로 결합이라면, 유니온(`UNION`)은 세로 결합이라는 점만 명심하시면 됩니다!
 */