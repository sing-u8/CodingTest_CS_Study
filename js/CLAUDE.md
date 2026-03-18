# js/ — JavaScript/TypeScript 풀이 가이드

## 환경
- Node.js 24.12.0 LTS (mise로 버전 고정)
- 기본 JS, 필요 시 TypeScript (`.ts`) 사용

## 새 문제 파일 위치
```
js/src/platform/<플랫폼>/
```
예:
- `src/platform/baekjoon/B_1197_최소스패닝트리.js`
- `src/platform/programmers/P_3_가장먼노드.js`

## 파일 템플릿
```js
const { tokens } = require("../../lib/io");

const t = tokens();
// 풀이
```

## 유틸리티
- `src/lib/io.js` — `tokens()` 함수로 stdin 토큰 파싱. 새 문제에서 항상 재사용할 것.

## 실행
```bash
cd js
node src/platform/baekjoon/B_XXXX_문제명.js < ../samples/baekjoon/XXXX/input.txt
# 또는
npm run solve -- platform/baekjoon/B_XXXX_문제명.js < ../samples/baekjoon/XXXX/input.txt
```

## TypeScript
```bash
npx tsx src/runner.js platform/baekjoon/B_XXXX_문제명.ts < ../samples/baekjoon/XXXX/input.txt
```

## 스킬
코딩 테스트 문제를 **풀거나 해설할 때** 반드시 `coding-test-mentor` 스킬을 사용한다.
