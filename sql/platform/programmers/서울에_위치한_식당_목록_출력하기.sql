-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131118
-- 서울에 위치한 식당 목록 출력하기
-- 레벨4

--- MYSQL

SELECT
    RI.REST_ID,
    RI.REST_NAME,
    RI.FOOD_TYPE,
    RI.FAVORITES,
    RI.ADDRESS,
    ROUND(AVG(RR.REVIEW_SCORE), 2) AS SCORE
FROM REST_INFO RI
         INNER JOIN REST_REVIEW RR ON RI.REST_ID = RR.REST_ID
WHERE RI.ADDRESS LIKE '서울%'
GROUP BY RI.REST_ID, RI.REST_NAME, RI.FOOD_TYPE, RI.FAVORITES, RI.ADDRESS
ORDER BY SCORE DESC, RI.FAVORITES DESC;

/*

### 상세 설명 및 수정 포인트

#### ① `WHERE RI.ADDRESS LIKE '서울%'` (누락된 부분)

* **이유:** 문제에서 "서울에 위치한 식당"들만 조회하라고 명시했습니다.
* **방법:** `ADDRESS` 컬럼이 '서울'로 시작하는 데이터를 찾기 위해 `LIKE '서울%'` 조건을 추가해야 합니다. 작성하신 쿼리에는 이 조건이 없어서 전국의 모든 식당이 계산되어 오답 처리된 것입니다.

#### ② `GROUP BY` 컬럼 추가 (표준 문법 준수)

* **작성하신 코드:** `GROUP BY RI.REST_ID`
* **수정된 코드:** `GROUP BY RI.REST_ID, RI.REST_NAME, ... (SELECT절에 있는 컬럼들)`
* **이유:** 최신 MySQL이나 Oracle 등에서는 집계 함수(`AVG`, `SUM` 등)를 제외한 `SELECT` 절의 모든 컬럼을 `GROUP BY` 절에 적어주는 것이 **표준 문법(ANSI SQL)**입니다.
* 물론 `REST_ID`가 기본키(PK)라면 `ID`만 적어도 실행되는 DB가 많지만, SQL 시험이나 엄격한 환경에서는 모든 컬럼을 나열하는 것이 정석입니다.



#### ③ `ROUND(AVG(...), 2)`

* **잘하셨습니다:** "소수점 세 번째 자리에서 반올림"이라는 말은, 결과적으로 **소수점 두 번째 자리까지 보여달라**는 뜻이므로 `2`를 입력하는 것이 맞습니다.

### 요약

작성하신 코드에서 **`WHERE RI.ADDRESS LIKE '서울%'`** 한 줄만 추가하면 정답에 가까워집니다! (안전하게 `GROUP BY` 컬럼도 다 채워주시면 100점입니다.)

 */