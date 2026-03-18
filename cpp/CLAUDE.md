# cpp/ — C++17 풀이 가이드

## 환경
- C++17, g++ (`-std=c++17 -O2 -Wall -Wextra`)
- 빌드 도구: Makefile

## 실행 방법
```bash
# cpp/ 디렉토리에서
make run FILE=src/platform/baekjoon/B_XXXX_문제명.cpp

# 샘플 입력 파이프
echo "1 2" | make run FILE=src/platform/baekjoon/B_0000_Template.cpp
# 또는
make run FILE=src/platform/baekjoon/B_XXXX_문제명.cpp < ../samples/B_XXXX.txt

# 빌드 아티팩트 정리
make clean
```

## 디렉토리 구조
```
cpp/
├── Makefile
└── src/
    ├── lib/
    │   └── io.hpp                  ← FastScanner (readInt/readLong/readWord/readLine)
    └── platform/
        └── baekjoon/
            └── B_XXXX_문제명.cpp
```

## 파일 네이밍
루트 CLAUDE.md 컨벤션 동일, 확장자 `.cpp`

| 플랫폼 | 패턴 | 예시 |
|--------|------|------|
| 백준 | `B_<번호>_<설명>.cpp` | `B_1197_최소스패닝트리.cpp` |
| 프로그래머스 | `P_<레벨>_<문제명>.cpp` | `P_3_가장먼노드.cpp` |

## 코드 스타일
- `#include "../../lib/io.hpp"` — IO 클래스로 빠른 입력
- 출력: `printf` 권장 (`cout` 사용 시 `ios::sync_with_stdio(false); cin.tie(nullptr);`)
- 전역 변수: 대규모 배열은 전역 선언 (스택 오버플로 방지)
- `#include <bits/stdc++.h>` 사용 가능 (경쟁 프로그래밍 관례)

## 템플릿
`src/platform/baekjoon/B_0000_Template.cpp` 참고
