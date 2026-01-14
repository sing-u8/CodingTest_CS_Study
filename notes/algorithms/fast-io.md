# Fast I/O (빠른 입출력)

코테에서는 입력이 커서 기본 입출력만으로는 느릴 수 있습니다. 언어별로 “빠른 입력” 템플릿을 고정해두면 문제 풀이 속도가 빨라집니다.

## Java

- `BufferedInputStream` 기반 스캐너 사용
- 관련 코드: `java/src/main/java/lib/FastScanner.java`

## JavaScript / Node

- `fs.readFileSync(0, "utf8")`로 한 번에 읽고 토큰화
- 관련 코드: `js/src/lib/io.js`

## 실전 예시

- Java: `java/src/main/java/platform/baekjoon/B_0000_Template.java`
- JS: `js/src/platform/baekjoon/B_0000_template.js`
- TS(옵션): `js/src/platform/baekjoon/B_0000_template.ts`

