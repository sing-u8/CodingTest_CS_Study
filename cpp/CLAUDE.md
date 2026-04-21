# cpp/ — C++17 풀이 가이드

## 환경
- C++17, g++ (`-std=c++17 -O2 -Wall -Wextra`)
- 빌드 도구: Makefile

## 실행 방법
```bash
# cpp/ 디렉토리에서
make run FILE=src/platform/leetcode/LC_XXXX_slug.cpp

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
        ├── leetcode/
        │   └── LC_XXXX_slug.cpp
        └── programmers/
            └── P_N_문제명.cpp
```

## 파일 네이밍
루트 CLAUDE.md 컨벤션 동일, 확장자 `.cpp`

| 플랫폼 | 패턴 | 예시 |
|--------|------|------|
| LeetCode | `LC_<번호>_<slug>.cpp` | `LC_0042_trapping-rain-water.cpp` |
| 프로그래머스 | `P_<레벨>_<문제명>.cpp` | `P_3_가장먼노드.cpp` |

## 코드 스타일
- `#include "../../lib/io.hpp"` — 프로그래머스 stdin 문제에서 빠른 입력이 필요할 때 사용
- 출력: `printf` 권장 (`cout` 사용 시 `ios::sync_with_stdio(false); cin.tie(nullptr);`)
- 전역 변수: 대규모 배열은 전역 선언 (스택 오버플로 방지)
- `#include <bits/stdc++.h>` 사용 가능 (경쟁 프로그래밍 관례)
