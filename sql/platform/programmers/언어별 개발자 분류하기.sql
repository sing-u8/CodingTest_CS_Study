-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/276036
-- 언어별 개발자 분류하기
-- 레벨4

--- MYSQL

SELECT
    CASE
        -- 3. 그룹화된 데이터 안에서 특정 스킬이 몇 개 있는지 SUM으로 확인하여 등급 부여
        WHEN SUM(CASE WHEN S.CATEGORY = 'Front End' THEN 1 ELSE 0 END) > 0
            AND SUM(CASE WHEN S.NAME = 'Python' THEN 1 ELSE 0 END) > 0 THEN 'A'
        WHEN SUM(CASE WHEN S.NAME = 'C#' THEN 1 ELSE 0 END) > 0 THEN 'B'
        WHEN SUM(CASE WHEN S.CATEGORY = 'Front End' THEN 1 ELSE 0 END) > 0 THEN 'C'
        END AS GRADE,
    D.ID,
    D.EMAIL
FROM DEVELOPERS D
-- 1. 비트 연산을 활용해 개발자가 가진 스킬들만 1:N으로 조인 (행이 늘어남)
         JOIN SKILLCODES S
              ON (D.SKILL_CODE & S.CODE) = S.CODE
-- 2. 늘어난 행을 다시 개발자(ID) 기준으로 그룹화
GROUP BY D.ID, D.EMAIL
-- 4. 등급이 부여되지 않은(NULL) 개발자는 제외
HAVING GRADE IS NOT NULL
ORDER BY GRADE ASC, D.ID ASC;


---


WITH SKILL_MASKS AS (
    SELECT
        SUM(CASE WHEN CATEGORY = 'Front End' THEN CODE ELSE 0 END) AS FE_MASK,
        SUM(CASE WHEN NAME = 'Python' THEN CODE ELSE 0 END) AS PY_MASK,
        SUM(CASE WHEN NAME = 'C#' THEN CODE ELSE 0 END) AS CS_MASK
    FROM SKILLCODES
),
GRADED_DEVELOPERS AS (
    SELECT
        CASE
            WHEN (D.SKILL_CODE & S.FE_MASK) > 0 AND (D.SKILL_CODE & S.PY_MASK) > 0 THEN 'A'
            WHEN (D.SKILL_CODE & S.CS_MASK) > 0 THEN 'B'
            WHEN (D.SKILL_CODE & S.FE_MASK) > 0 THEN 'C'
            ELSE NULL
        END AS GRADE,
        D.ID,
        D.EMAIL
    FROM DEVELOPERS D
    CROSS JOIN SKILL_MASKS S
)

SELECT GRADE, ID, EMAIL
FROM GRADED_DEVELOPERS
WHERE GRADE IS NOT NULL
ORDER BY GRADE ASC, ID ASC;
