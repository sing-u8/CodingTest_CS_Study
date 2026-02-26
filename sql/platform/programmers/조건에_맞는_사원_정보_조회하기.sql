-- Programmers SQL Template
-- https://school.programmers.co.kr/learn/courses/30/lessons/284527
-- 조건에 맞는 사원 정보 조회하기
-- 레벨2

--- MYSQL

SELECT SUM(HG.SCORE) AS SCORE, HE.EMP_NO, HE.EMP_NAME, HE.POSITION, HE.EMAIL
FROM HR_EMPLOYEES HE
         INNER JOIN HR_GRADE HG ON HE.EMP_NO = HG.EMP_NO
WHERE HG.YEAR = 2022
GROUP BY HE.EMP_NO, HE.EMP_NAME, HE.POSITION, HE.EMAIL
ORDER BY SCORE DESC
    LIMIT 1;


/*

이 문제는 여러 테이블에 흩어진 데이터를 조합하고, **"그룹별 합계(SUM)"**를 구한 뒤 **"그중 최댓값"**을 찾는 전형적인 실무형 SQL 문제입니다.

특히 상반기/하반기 점수가 각각의 행(Row)으로 나뉘어 있기 때문에, 이를 먼저 하나로 합쳐주는 작업이 핵심입니다. 또한, 부서 정보 테이블(`HR_DEPARTMENT`)이 주어졌지만, 최종 출력에는 부서 관련 정보가 없으므로 **실제로는 조인할 필요가 없는 "함정" 테이블**이라는 점도 파악해야 합니다.

가장 직관적인 `LIMIT` 활용 방법과, 공동 1등까지 완벽하게 처리하는 `WITH` 구문 활용 방법 2가지를 알려드릴게요.

---

### 💡 해결 방법 1: `ORDER BY`와 `LIMIT` (가장 직관적이고 쉬운 풀이)

합계를 구한 후 점수 순으로 내림차순 정렬하여 가장 위에 있는 1명만 뽑아내는 방식입니다. MySQL 환경의 코딩 테스트에서 가장 많이 쓰이는 패턴입니다.

#### **SQL 코드 (MySQL)**

```sql
SELECT
    SUM(G.SCORE) AS SCORE,
    E.EMP_NO,
    E.EMP_NAME,
    E.POSITION,
    E.EMAIL
FROM HR_GRADE G
JOIN HR_EMPLOYEES E
    ON G.EMP_NO = E.EMP_NO
WHERE G.YEAR = 2022
GROUP BY G.EMP_NO, E.EMP_NAME, E.POSITION, E.EMAIL
ORDER BY SCORE DESC
LIMIT 1;

```

#### **코드 상세 해설**

1. **`JOIN`**: 성명, 직책, 이메일을 가져오기 위해 평가 테이블(`G`)과 사원 테이블(`E`)을 사번(`EMP_NO`) 기준으로 연결합니다.
2. **`WHERE G.YEAR = 2022`**: 2022년도 평가 기록만 필터링합니다.
3. **`GROUP BY ...`**: 사원별로 상/하반기 점수를 묶습니다.
4. **`SUM(G.SCORE) AS SCORE`**: 묶인 상/하반기 점수를 합산하여 `SCORE`라는 별칭을 붙입니다.
5. **`ORDER BY SCORE DESC LIMIT 1`**: 총점이 가장 높은 순서대로 정렬(내림차순)한 뒤, 최상위 1건만 가져옵니다.

---

### 💡 해결 방법 2: `WITH` 구문 (CTE) 사용 (공동 1등까지 처리하는 완벽한 풀이)

만약 1등이 2명 이상일 수 있다는 조건이 있다면 `LIMIT 1`로는 한 명밖에 조회되지 않습니다. 이럴 때는 임시 테이블(`WITH` 절)을 만들어 최고 점수를 찾고, 그 점수와 일치하는 사람을 모두 뽑아내는 것이 정석입니다.

#### **SQL 코드 (표준 SQL)**

```sql
-- 1단계: 사원별 2022년 총점수 임시 테이블 만들기
WITH TOTAL_SCORES AS (
    SELECT EMP_NO, SUM(SCORE) AS SCORE
    FROM HR_GRADE
    WHERE YEAR = 2022
    GROUP BY EMP_NO
)

-- 2단계: 최고 점수를 가진 사원 정보 조회
SELECT
    T.SCORE,
    E.EMP_NO,
    E.EMP_NAME,
    E.POSITION,
    E.EMAIL
FROM TOTAL_SCORES T
JOIN HR_EMPLOYEES E
    ON T.EMP_NO = E.EMP_NO
WHERE T.SCORE = (SELECT MAX(SCORE) FROM TOTAL_SCORES);

```

#### **코드 상세 해설**

1. **`WITH TOTAL_SCORES AS (...)`**: 복잡한 서브쿼리 대신 코드를 깔끔하게 분리해 주는 기능입니다. 여기서 사번과 2022년도 총합 점수만 먼저 구해놓습니다.
2. **`WHERE T.SCORE = (SELECT MAX(SCORE) FROM TOTAL_SCORES)`**: 방금 만든 임시 테이블에서 가장 높은 점수(`MAX`)를 찾고, 본인의 총점이 그 최고점과 동일한 사원들만 최종적으로 걸러냅니다.

---

### 🧠 데이터 처리 흐름 시각화

```text
[1. HR_GRADE 원본]         [2. GROUP BY & SUM]         [3. JOIN & 최댓값 필터링]
사번      반기  점수          사번      총점(SCORE)        최종 결과
2020002   1    90    --->   2020002   181 (1등!)   --->  181 | 2020002 | 김연주 | 팀원 | ...
2020002   2    91
2017002   1    92    --->   2017002   176
2017002   2    84

```

### 🚀 마스터의 팁

실제 코딩 테스트 플랫폼(프로그래머스 등)에서는 **방법 1 (`LIMIT`)**만으로도 정답 처리가 되는 경우가 대부분입니다. 코드가 훨씬 짧고 작성하기 편하기 때문이죠.

하지만 면접이나 실무에서 "만약 동점자가 있다면 어떻게 쿼리를 짤 것인가?"라는 질문을 받을 수 있으니, **방법 2 (`WITH` + `MAX` 서브쿼리)** 또는 앞서 배웠던 **`RANK()` 윈도우 함수**를 활용하는 방법도 꼭 숙지해 두시는 것을 권장합니다!

혹시 코드를 실행해 보시다가 막히는 부분이 있거나, 윈도우 함수(`RANK()`)를 적용한 버전도 궁금하시다면 언제든 말씀해 주세요!

 */

 /*

`WITH` 구문(CTE: Common Table Expression)에 대해 질문해 주셨군요! 아주 훌륭한 질문입니다. CTE는 코딩 테스트의 고득점 문제(Level 4 이상)는 물론, 현업 실무 데이터 분석에서도 **가장 사랑받는 SQL 문법 중 하나**입니다.

CTE가 무엇인지, 왜 쓰는지, 그리고 어떻게 쓰는지 아주 알기 쉽게 쪼개서 설명해 드릴게요.

---

### 1. CTE (`WITH` 구문)란 무엇인가요?

쉽게 말해 **"메인 쿼리를 실행하기 전에 미리 만들어두는 '임시 테이블(또는 변수)'"**입니다.
복잡한 `FROM` 절 안의 서브쿼리(Subquery)를 밖으로 빼내어 이름을 붙여주는 역할을 합니다.

* **요리 비유**: 요리를 할 때 냄비에 모든 재료를 한 번에 썰어 넣으면서 끓이는 것(서브쿼리)이 아니라, **"미리 재료를 손질해서 그릇에 담아두고(CTE), 나중에 그 그릇들을 조합해서 요리(메인 쿼리)하는 것"**과 같습니다.

---

### 2. 왜 서브쿼리 대신 CTE를 쓸까요? (핵심 장점)

#### ① 압도적인 가독성 (읽기 편함)

서브쿼리를 쓰면 쿼리가 "양파 껍질"처럼 괄호 안으로 계속 파고들어 갑니다. 코드를 읽을 때 제일 안쪽 괄호부터 찾아 읽어야 하죠.
하지만 CTE를 쓰면 코드가 **위에서 아래로 자연스럽게** 흐릅니다.

```text
[ 기존 서브쿼리 방식 (해석: 안쪽 ➡️ 바깥쪽) ]
SELECT * FROM (
    SELECT * FROM (
        SELECT * FROM 원본_테이블  -- 여기서부터 읽어야 함!
    ) B
) A;

[ WITH 구문 방식 (해석: 위 ➡️ 아래) ]
WITH 임시테이블_1 AS (SELECT * FROM 원본_테이블), -- 1. 먼저 이걸 만들고
     임시테이블_2 AS (SELECT * FROM 임시테이블_1)   -- 2. 그걸로 이걸 만들고
SELECT * FROM 임시테이블_2;                     -- 3. 최종 출력!

```

#### ② 재사용성 (효율성)

메인 쿼리 안에서 똑같은 서브쿼리를 두세 번 써야 할 때가 있습니다. 서브쿼리는 똑같은 코드를 계속 복사/붙여넣기 해야 하지만, CTE는 **한 번 만들어두면 메인 쿼리에서 여러 번 재사용**할 수 있습니다.

---

### 3. `WITH` 구문 기본 문법

문법은 매우 간단합니다. `WITH` 키워드 뒤에 사용할 이름과 괄호 `()`를 적어주면 됩니다.

```sql
-- 1. 임시 테이블 정의 (여러 개 만들 때는 쉼표(,)로 구분)
WITH
    임시테이블_A AS (
        SELECT 부서ID, COUNT(*) AS 인원수
        FROM 사원테이블
        GROUP BY 부서ID
    ),
    임시테이블_B AS (
        SELECT 부서ID, SUM(급여) AS 총급여
        FROM 사원테이블
        GROUP BY 부서ID
    )

-- 2. 메인 쿼리 (위에서 만든 A와 B를 진짜 테이블처럼 사용)
SELECT A.부서ID, A.인원수, B.총급여
FROM 임시테이블_A A
JOIN 임시테이블_B B ON A.부서ID = B.부서ID;

```

---

### 4. 실제 문제에 적용했던 예시 복습

이전에 풀었던 "2022년 평가 점수 최고점자 찾기" 문제에서 제가 CTE를 썼던 로직을 다시 한번 살펴볼까요?

1. **`WITH TOTAL_SCORES AS (...)`**
* "일단 복잡하게 다른 테이블이랑 조인하기 전에, `HR_GRADE` 테이블만 가지고 사원별 2022년도 총합 점수판을 'TOTAL_SCORES'라는 이름으로 미리 만들어둘게!"


2. **`SELECT ... FROM TOTAL_SCORES T JOIN ...`**
* "이제 방금 만든 'TOTAL_SCORES' 점수판이랑 사원 정보 테이블을 합쳐서, 제일 점수 높은 사람을 뽑아내자!"



이렇게 논리적인 단계를 딱딱 나누어주기 때문에 복잡한 문제를 풀 때 생각의 흐름을 정리하기가 아주 좋습니다.

  */