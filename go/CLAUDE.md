# go/ — Go 풀이 가이드

## 환경
- Go 1.23 (mise로 버전 고정)
- 빌드 도구: go build / Makefile

## 실행 방법
```bash
# go/ 디렉토리에서
go run cmd/platform/leetcode/LC_XXXX_slug.go

# Makefile 사용
make run FILE=cmd/platform/leetcode/LC_XXXX_slug.go

# 전체 빌드 확인
go build ./cmd/...
```

## 디렉토리 구조
```
go/
├── go.mod
├── Makefile
└── cmd/platform/
    ├── leetcode/
    │   └── LC_XXXX_slug.go
    └── programmers/
        └── P_N_문제명.go
```

각 `.go` 파일은 `package main`으로 독립 실행 가능.

## 파일 네이밍
루트 CLAUDE.md 컨벤션 동일, 확장자 `.go`

| 플랫폼 | 패턴 | 예시 |
|--------|------|------|
| LeetCode | `LC_<번호>_<slug>.go` | `LC_0042_trapping-rain-water.go` |
| 프로그래머스 | `P_<레벨>_<문제명>.go` | `P_3_가장먼노드.go` |

## 입력 파싱 패턴
```go
reader := bufio.NewReader(os.Stdin)
writer := bufio.NewWriter(os.Stdout)
defer writer.Flush()

var n int
fmt.Fscan(reader, &n)          // 공백/개행 기준 토큰 파싱
fmt.Fprintln(writer, n)        // 버퍼 출력
```
`bufio.NewReader` + `fmt.Fscan` — 버퍼 기반 빠른 토큰 파싱

## 코드 스타일
- 입력: `bufio.NewReader` + `fmt.Fscan` (프로그래머스 stdin 기반 문제에서 사용)
- 출력: `bufio.NewWriter` + `fmt.Fprintln` (버퍼 출력, `defer writer.Flush()` 필수)
- 대규모 배열: 전역 변수 선언 (스택 제한 회피)

## 스킬
코딩 테스트 문제를 **풀거나 해설할 때** 반드시 `coding-test-mentor` 스킬을 사용한다.
