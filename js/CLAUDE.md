# js/ — JavaScript/TypeScript 풀이 가이드

## 환경
- Node.js 24.12.0 LTS (mise로 버전 고정)
- 기본 JS, 필요 시 TypeScript (`.ts`) 사용

## 새 문제 파일 위치
```
js/src/platform/<플랫폼>/
```
예:
- `src/platform/leetcode/LC_0042_trapping-rain-water.js`
- `src/platform/programmers/P_3_가장먼노드.js`

## 파일 템플릿
```js
const { tokens } = require("../../lib/io");

const t = tokens();
// 풀이
```

## 유틸리티
- `src/lib/io.js` — `tokens()` 함수로 stdin 토큰 파싱. 프로그래머스 stdin 기반 문제에서 재사용.

## 실행
```bash
cd js
node src/platform/leetcode/LC_XXXX_slug.js
# 또는
npm run solve -- platform/leetcode/LC_XXXX_slug.js
```

## TypeScript
```bash
npx tsx src/runner.js platform/leetcode/LC_XXXX_slug.ts
```

## 스킬
코딩 테스트 문제를 **풀거나 해설할 때** 반드시 `coding-test-mentor` 스킬을 사용한다.
