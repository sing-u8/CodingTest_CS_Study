-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131116
-- 식품분류별 가장 비싼 식품의 정보 조회하기
-- 레벨4

--- MYSQL
WITH RankedProducts AS (
    SELECT
        CATEGORY,
        PRICE AS MAX_PRICE,
        PRODUCT_NAME,
        -- 카테고리별로(PARTITION BY) 가격을 내림차순 정렬(ORDER BY)하여 순위를 매김
        RANK() OVER(PARTITION BY CATEGORY ORDER BY PRICE DESC) as rnk
    FROM FOOD_PRODUCT
    WHERE CATEGORY IN ('과자', '국', '김치', '식용유')
)
SELECT
    CATEGORY,
    MAX_PRICE,
    PRODUCT_NAME
FROM RankedProducts
WHERE rnk = 1 -- 그룹별 1등(최고가)만 추출
ORDER BY MAX_PRICE DESC;

---

SELECT
    CATEGORY,
    PRICE AS MAX_PRICE,
    PRODUCT_NAME
FROM FOOD_PRODUCT
WHERE (CATEGORY, PRICE) IN (
      SELECT CATEGORY, MAX(PRICE)
      FROM FOOD_PRODUCT
      WHERE CATEGORY IN ('과자', '국', '김치', '식용유')
      GROUP BY CATEGORY
  )
ORDER BY MAX_PRICE DESC;

---

SELECT
    A.CATEGORY,
    B.MAX_PRICE,
    A.PRODUCT_NAME
FROM FOOD_PRODUCT A
INNER JOIN (
    SELECT CATEGORY, MAX(PRICE) AS MAX_PRICE
    FROM FOOD_PRODUCT
    WHERE CATEGORY IN ('과자', '국', '김치', '식용유')
    GROUP BY CATEGORY
) B ON A.CATEGORY = B.CATEGORY AND A.PRICE = B.MAX_PRICE
ORDER BY B.MAX_PRICE DESC;