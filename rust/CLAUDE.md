# rust/ — Rust 풀이 가이드

## 환경
- Rust stable (edition 2021)
- 빌드 도구: Cargo

## 실행 방법
```bash
# rust/ 디렉토리에서
cargo run --bin B_XXXX_문제명

# 샘플 입력 파이프
echo "1 2" | cargo run --bin B_0000_Template
# 또는
cargo run --bin B_XXXX_문제명 < ../samples/B_XXXX.txt

# 릴리즈 빌드 (속도 최적화)
cargo run --release --bin B_XXXX_문제명

# 전체 빌드 확인
cargo build
```

## 디렉토리 구조
```
rust/
├── Cargo.toml
└── src/bin/
    └── B_XXXX_문제명.rs     ← 파일명 = 바이너리명
```

`src/bin/*.rs` 파일은 Cargo가 자동으로 바이너리로 인식한다. `[[bin]]` 항목 추가 불필요.

## 파일 네이밍
루트 CLAUDE.md 컨벤션 동일, 확장자 `.rs`

| 플랫폼 | 패턴 | 예시 |
|--------|------|------|
| 백준 | `B_<번호>_<설명>.rs` | `B_1197_최소스패닝트리.rs` |
| 프로그래머스 | `P_<레벨>_<문제명>.rs` | `P_3_가장먼노드.rs` |

## 입력 파싱 패턴
```rust
use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut iter = input.split_ascii_whitespace();
    macro_rules! next {
        ($t:ty) => { iter.next().unwrap().parse::<$t>().unwrap() }
    }
    // let n = next!(usize);
    // let x = next!(i64);
}
```
`read_to_string` + `split_ascii_whitespace` — 버퍼 기반 빠른 토큰 파싱

## 템플릿
`src/bin/B_0000_Template.rs` 참고
