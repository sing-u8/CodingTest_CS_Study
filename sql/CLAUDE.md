# sql/ — SQL 풀이 가이드

## 환경
- 프로그래머스: MySQL 기준
- LeetCode: MySQL / PostgreSQL 선택 가능
- SQLP 대비: Oracle 문법 참고

## SQL 파일 위치
```
sql/platform/<플랫폼>/<문제명>.sql
```
예:
- `sql/platform/programmers/가장먼노드.sql`
- `sql/platform/leetcode/LC_0185_department-top-three-salaries.sql`

## 재사용 패턴
`sql/snippets/` 디렉토리에 자주 쓰는 SQL 패턴이 있다. 새 문제 풀이 전 참고할 것.
- `snippets/window-functions.sql` — 윈도우 함수 예제 모음

## 작성 규칙
- 프로그래머스 기본 환경은 MySQL이므로 MySQL 문법 우선
- CTE(`WITH`) 적극 활용하여 가독성 향상
- 복잡한 쿼리는 단계별 주석 추가
- 비트 연산, 조건부 집계(`SUM(IF(...))`) 등 플랫폼 특화 기법 활용 가능

## 스킬
SQL 문제를 **풀거나 해설할 때** 반드시 `sql-tutor` 스킬을 사용한다.
