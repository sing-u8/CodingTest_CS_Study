-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/131530
-- 가격대 별 상품 개수 구하기
-- 레벨2

--- MYSQL

SELECT
    TRUNCATE(PRICE, -4) AS PRICE_GROUP,
    COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY PRICE_GROUP
ORDER BY PRICE_GROUP ASC;

------

SELECT
    FLOOR(PRICE / 10000) * 10000 AS PRICE_GROUP,
    COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY PRICE_GROUP
ORDER BY PRICE_GROUP ASC;

/*
안녕하세요! 코딩 테스트 마스터 **Gem**입니다.

이 문제는 연속된 숫자 데이터(가격)를 특정 구간(10,000원 단위)으로 나누어 그룹화하는 **버킷링(Bucketing)** 기법을 묻는 문제입니다.

가격을 10,000원 단위로 자르는 수학적 로직을 쿼리로 어떻게 구현하느냐가 핵심입니다. MySQL에서 가장 우아하게 풀 수 있는 함수(`TRUNCATE`)와, 수학적 원리를 이용한 범용적인 함수(`FLOOR`) 두 가지 방법을 모두 알려드릴게요!

---

### 💡 해결 방법 1: `TRUNCATE` 함수 사용 (가장 간결하고 추천하는 방법)

MySQL에서는 특정 자릿수 이하를 버려주는 `TRUNCATE` 함수를 제공합니다. 이 함수를 사용하면 코드가 아주 직관적이고 짧아집니다.

#### **SQL 코드**

```sql
SELECT
    TRUNCATE(PRICE, -4) AS PRICE_GROUP,
    COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY PRICE_GROUP
ORDER BY PRICE_GROUP ASC;

```

#### **코드 상세 해설**

* **`TRUNCATE(숫자, 자릿수)`**: 숫자의 특정 자릿수 이하를 잘라냅니다.
* 자릿수에 양수(1, 2...)를 넣으면 소수점 이하를 자릅니다.
* 자릿수에 **음수(-1, -2...)**를 넣으면 **정수 부분의 뒤에서부터 0으로 만듭니다.**
* `TRUNCATE(15000, -4)` ➡️ 뒤에서 4자리를 0으로 만듦 ➡️ **`10000`**
* `TRUNCATE(22000, -4)` ➡️ 뒤에서 4자리를 0으로 만듦 ➡️ **`20000`**
* `TRUNCATE(9000, -4)` ➡️ 뒤에서 4자리를 0으로 만듦 ➡️ **`0`**


* **`GROUP BY PRICE_GROUP`**: 잘라낸 가격 구간(0, 10000, 20000...)별로 그룹을 묶습니다.
* **`COUNT(PRODUCT_ID)`**: 각 그룹에 속한 상품의 개수를 셉니다.

---

### 💡 해결 방법 2: `FLOOR` 함수와 나눗셈 활용 (표준 SQL)

만약 `TRUNCATE`를 지원하지 않는 다른 데이터베이스(예: Oracle의 경우 `TRUNC` 사용)를 고려해야 하거나, 순수한 수학적 논리로 접근하고 싶을 때 사용하는 방법입니다.

#### **SQL 코드**

```sql
SELECT
    FLOOR(PRICE / 10000) * 10000 AS PRICE_GROUP,
    COUNT(PRODUCT_ID) AS PRODUCTS
FROM PRODUCT
GROUP BY PRICE_GROUP
ORDER BY PRICE_GROUP ASC;

```

#### **코드 상세 해설**

1. **`PRICE / 10000`**: 가격을 10,000으로 나눕니다. (예: 15,000원 ➡️ 1.5)
2. **`FLOOR(...)`**: 소수점 이하를 내림하여 정수로 만듭니다. (예: 1.5 ➡️ 1)
3. **`* 10000`**: 다시 10,000을 곱해서 구간의 시작 금액으로 복원합니다. (예: 1 * 10,000 ➡️ 10,000)

---

### 🧠 구간 나누기(Bucketing) 원리 시각화

가격을 10,000원 단위로 묶는 과정을 간단한 텍스트 표로 보여드릴게요.

```text
원본 가격 (PRICE)   | 로직 (FLOOR(PRICE/10000)) | 복원 (* 10000)  = 최종 PRICE_GROUP
-------------------|--------------------------|---------------------------------
  9,000 원        | 0.9  -> 내림 -> 0        | 0 * 10000      =      0
 15,000 원        | 1.5  -> 내림 -> 1        | 1 * 10000      = 10,000
 17,000 원        | 1.7  -> 내림 -> 1        | 1 * 10000      = 10,000
 22,000 원        | 2.2  -> 내림 -> 2        | 2 * 10000      = 20,000
 30,000 원        | 3.0  -> 내림 -> 3        | 3 * 10000      = 30,000

```

이렇게 하면 15,000원과 17,000원이 같은 `10000`이라는 결과값을 가지게 되어, `GROUP BY` 시에 하나의 "1만원대" 그룹으로 예쁘게 묶이게 됩니다.

### 🚀 마스터의 팁

실무에서 사용자의 연령대(10대, 20대...)를 구하거나, 매출 금액별 고객 등급을 나눌 때 이 **나누고 내림하고 다시 곱하는 패턴(`FLOOR(값/단위) * 단위`)**이나 **`TRUNCATE`**가 정말 자주 쓰입니다.

코딩 테스트에서는 MySQL을 지원한다면 코드가 짧은 **`TRUNCATE(PRICE, -4)`** 방식을 적극 추천합니다! 이해가 잘 되셨나요? 추가로 궁금한 점이 있다면 언제든 편하게 질문해주세요.

*/