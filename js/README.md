# JavaScript (Node)

- `src/platform/`: 플랫폼별 풀이
- `src/lib/`: 재사용 유틸
- `src/runner.js`: 특정 풀이 파일을 인자로 받아 실행하는 러너(디버깅 편의)

## 실행

```bash
cd js
npm install
node src/runner.js platform/baekjoon/B_0000_template.js < ../samples/baekjoon/0000/input.txt
```

## TypeScript(옵션)

```bash
cd js
npx tsx src/runner.js platform/baekjoon/B_0000_template.ts < ../samples/baekjoon/0000/input.txt
```
