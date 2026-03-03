-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/284528
-- 연간 평가점수에 해당하는 평가 등급 및 성과금 조회하기
-- 레벨4

--- MySQL

WITH GRADE_INFO AS (
    SELECT
        EMP_NO,
        CASE
            WHEN AVG(SCORE) >= 96 THEN 'S'
            WHEN AVG(SCORE) >= 90 THEN 'A'
            WHEN AVG(SCORE) >= 80 THEN 'B'
            ELSE 'C'
            END AS GRADE,
        CASE
            WHEN AVG(SCORE) >= 96 THEN 0.2
            WHEN AVG(SCORE) >= 90 THEN 0.15
            WHEN AVG(SCORE) >= 80 THEN 0.10
            ELSE 0
            END AS RATIO
    FROM HR_GRADE
    GROUP BY EMP_NO
)

SELECT
    E.EMP_NO,
    E.EMP_NAME,
    G.GRADE,
    (E.SAL * G.RATIO) AS BONUS
FROM HR_EMPLOYEES E
         INNER JOIN GRADE_INFO G
                    ON E.EMP_NO = G.EMP_NO
ORDER BY E.EMP_NO ASC;


---


-- 1. 사원별 평균 평가 점수를 먼저 계산해 둡니다.
WITH AVG_GRADE AS (
    SELECT
        EMP_NO,
        AVG(SCORE) AS AVG_SCORE
    FROM HR_GRADE
    WHERE YEAR = 2022 -- (생략해도 무방하나, 2022년 평가 정보라는 문제 설명을 명시적으로 반영)
GROUP BY EMP_NO
    )

-- 2. 사원 정보 테이블과 평균 점수 테이블을 조인하여 결과를 출력합니다.
SELECT
    E.EMP_NO,
    E.EMP_NAME,

    -- 평균 점수를 기준으로 등급 산정
    CASE
        WHEN A.AVG_SCORE >= 96 THEN 'S'
        WHEN A.AVG_SCORE >= 90 THEN 'A'
        WHEN A.AVG_SCORE >= 80 THEN 'B'
        ELSE 'C'
        END AS GRADE,

    -- 등급(평균 점수)에 따른 성과금(보너스) 계산
    CASE
        WHEN A.AVG_SCORE >= 96 THEN E.SAL * 0.20
        WHEN A.AVG_SCORE >= 90 THEN E.SAL * 0.15
        WHEN A.AVG_SCORE >= 80 THEN E.SAL * 0.10
        ELSE 0
        END AS BONUS

FROM HR_EMPLOYEES E
         JOIN AVG_GRADE A ON E.EMP_NO = A.EMP_NO
ORDER BY E.EMP_NO ASC;