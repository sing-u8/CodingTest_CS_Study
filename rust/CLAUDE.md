# rust/ — Rust 풀이 가이드

## 환경
- Rust stable (edition 2021)
- 빌드 도구: Cargo

## 실행 방법
```bash
# rust/ 디렉토리에서
cargo run --bin LC_XXXX_slug

# 릴리즈 빌드 (속도 최적화)
cargo run --release --bin LC_XXXX_slug

# 전체 빌드 확인
cargo build
```

## 디렉토리 구조
```
rust/
├── Cargo.toml
└── src/bin/
    └── LC_XXXX_slug.rs     ← 파일명 = 바이너리명 (평탄 구조)
```

`src/bin/*.rs` 파일은 Cargo가 자동으로 바이너리로 인식한다. `[[bin]]` 항목 추가 불필요. Cargo 규약상 평탄 구조이므로 플랫폼별 서브폴더를 두지 않고 파일명 prefix(`LC_`, `P_`)로 구분한다.

## 파일 네이밍
루트 CLAUDE.md 컨벤션 동일, 확장자 `.rs`

| 플랫폼 | 패턴 | 예시 |
|--------|------|------|
| LeetCode | `LC_<번호>_<slug>.rs` | `LC_0042_trapping-rain-water.rs` |
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
`read_to_string` + `split_ascii_whitespace` — 프로그래머스 stdin 기반 문제에서 사용
