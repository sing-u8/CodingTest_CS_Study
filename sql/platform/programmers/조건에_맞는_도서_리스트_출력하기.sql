-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/144853
-- 조건에 맞는 도서 리스트 출력하기
-- 레벨1

-- ORACLE
SELECT BOOK_ID,
       TO_CHAR(PUBLISHED_DATE, 'YYYY-MM-DD') AS PUBLISHED_DATE
FROM BOOK
WHERE CATEGORY = '인문'
  AND (PUBLISHED_DATE >= TO_DATE('2021-01-01', 'YYYY-MM-DD')
    AND PUBLISHED_DATE < TO_DATE('2022-01-01', 'YYYY-MM-DD'))
ORDER BY PUBLISHED_DATE ASC;

-- MYSQL
SELECT BOOK_ID, DATE_FORMAT(PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK
WHERE CATEGORY = '인문'
  AND PUBLISHED_DATE >= '2021-01-01'
  AND PUBLISHED_DATE < '2022-01-01'
ORDER BY PUBLISHED_DATE;

/*
1. 왜 WHERE 절을 이렇게(범위 조건) 작성해야 하나요?
핵심 이유: "인덱스(Index)를 타게 하기 위해서"

도서관에서 2021년에 출판된 책을 찾는 상황을 상상해 보세요.

❌ 나쁜 방법 (좌변 가공)
SQL

WHERE YEAR(PUBLISHED_DATE) = 2021
동작: 도서관의 모든 책을 하나씩 꺼내서 출판일을 확인하고 연도를 계산해 봅니다.

문제: 책이 100만 권이면 100만 번 계산해야 합니다. (Full Table Scan)

이유: PUBLISHED_DATE 컬럼에 '색인(Index)'이 붙어 있어도, 함수(YEAR)로 감싸버리면 색인의 모양과 달라져서 색인을 사용할 수 없습니다.

✅ 좋은 방법 (범위 조건)
SQL

WHERE PUBLISHED_DATE >= '2021-01-01' AND ...
동작: 도서관 색인(목차)에서 '2021-01-01'이라고 적힌 페이지를 딱 펼칩니다. 거기서부터 '2022-01-01' 전까지만 쭉 훑고 끝냅니다.

장점: 데이터가 아무리 많아도, 해당 날짜 구간만 읽으므로 압도적으로 빠릅니다. (Index Range Scan)

2. 왜 MySQL은 타입 변환 없이 비교가 되나요?
핵심 이유: "암시적 형변환 (Implicit Type Conversion)"

🐬 MySQL의 특징: "친절하고 유연함"
MySQL은 개발자의 편의를 위해 설계된 부분이 많습니다.

PUBLISHED_DATE 컬럼이 DATE 타입이고, 비교하려는 값이 '2021-01-01'이라는 문자열(String) 이라면?

MySQL 옵티마이저(최적화 담당)가 생각합니다.

"아, 사용자가 날짜 컬럼이랑 비교하네? 그럼 이 문자열을 내가 알아서 날짜로 바꿔서 비교해 줘야겠다."

이 과정을 암시적 형변환이라고 합니다. 그래서 TO_DATE 없이도 잘 동작합니다.

🔴 Oracle의 특징: "엄격하고 정확함"
Oracle도 설정에 따라 암시적 변환이 되긴 하지만, 기본적으로 매우 엄격합니다.

Oracle은 날짜 포맷 설정(NLS_DATE_FORMAT)이 서버마다, 혹은 접속한 사용자(세션)마다 다를 수 있습니다.

어떤 컴퓨터에서는 '21/01/01'로 인식하고, 어떤 컴퓨터에서는 '2021-01-01'로 인식할 수 있습니다.

그래서 문자열을 그대로 날짜와 비교하면, "설정에 따라 에러가 나거나 엉뚱한 결과가 나올 수 있으니, 네가 명확하게 TO_DATE로 바꿔서 줘!" 라고 하는 경향이 강합니다.

실무에서는 안전을 위해 Oracle 쿼리 작성 시 반드시 **명시적 형변환(TO_DATE)**을 사용하는 것이 원칙입니다.

요약
범위 조건 사용 이유: 원본 데이터(컬럼)를 건드리지 않아야 **인덱스(색인)**를 사용하여 검색 속도가 빨라지기 때문입니다.

MySQL이 그냥 되는 이유: MySQL 내부 엔진이 알아서 문자열을 날짜로 바꿔주는 **친절한 기능(암시적 형변환)**이 내장되어 있기 때문입니다. (하지만 Oracle에서는 명시적으로 써주는 게 안전합니다.)

 */