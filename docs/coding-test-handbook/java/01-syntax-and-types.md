# Java 코딩테스트 문법과 자료형

기준은 Java 21이며, 코딩테스트에서 자주 쓰는 부분에 집중한다.

## 1. 기본 제출 구조

```java
import java.io.*;
import java.util.*;

public class Main {
    public static void main(String[] args) throws Exception {
        BufferedReader br = new BufferedReader(
                new InputStreamReader(System.in)
        );

        StringBuilder out = new StringBuilder();
        out.append("answer");
        System.out.print(out);
    }
}
```

프로그래머스에서는 보통 `class Solution`과 `solution()` 메서드만 작성한다.

## 2. 프리미티브와 참조 타입

| 타입 | 크기 | 코딩테스트 용도 |
|---|---:|---|
| `boolean` | JVM 구현 의존 | 방문 여부 |
| `char` | 16비트 | UTF-16 코드 단위, 영문자 처리 |
| `int` | 32비트 | 인덱스, 작은 합 |
| `long` | 64비트 | 거리, 큰 합과 곱 |
| `double` | 64비트 | 실수 계산 |

`String`, 배열, 컬렉션은 참조 타입이다. 변수에는 객체 자체가 아니라 객체를 가리키는 참조가 들어간다.

```java
int a = 10;
long distance = 3_000_000_000L;
double ratio = 1.5;
char letter = 'A';
boolean visited = false;
String word = "hello";
```

### 산술식의 타입과 오버플로 예방

산술 연산의 타입은 결과를 저장할 변수의 타입이 아니라 **연산에 참여하는 피연산자의 타입**으로 결정된다.
따라서 `int`끼리 곱하면 결과도 `int`로 계산된 후 `long`에 대입된다.

```java
int a = 100_000;
int b = 100_000;

long wrong = a * b;       // int 곱셈에서 이미 오버플로
long right = 1L * a * b;  // 첫 연산부터 long
```

`wrong`의 처리 순서는 다음과 같다.

```text
a(int) * b(int)
        ↓
int 범위에서 곱셈
        ↓
오버플로가 발생한 int 결과
        ↓
이미 잘못된 값을 long으로 변환
```

피연산자 중 하나를 곱셈 **전에** `long`으로 바꾸면 나머지 피연산자도 `long`으로 승격된다.

```java
long result1 = (long) a * b;
long result2 = 1L * a * b;
```

캐스팅의 위치에도 주의한다.

```java
long wrongCast = (long) (a * b); // a * b가 int로 먼저 계산됨
long rightCast = (long) a * b;   // a를 먼저 long으로 변환
```

연산이 이어질 때는 왼쪽부터 계산하므로 처음부터 `long` 연산으로 만드는 것이 안전하다.

```java
int x = 100_000;
int y = 100_000;
int z = 2;

long wrongOrder = x * y * 1L * z; // x * y에서 먼저 오버플로 가능
long rightOrder = 1L * x * y * z;
```

코딩테스트에서는 합계, 거리, 경우의 수, 넓이처럼 값이 커질 수 있는 계산에 이 패턴을 자주 사용한다.

```java
long area = 1L * width * height;
long combinations = 1L * n * (n - 1) / 2;
```

## 3. 박싱과 언박싱

컬렉션에는 프리미티브를 직접 넣을 수 없어 래퍼 타입을 사용한다.

```text
int     ↔ Integer
long    ↔ Long
double  ↔ Double
char    ↔ Character
```

```java
List<Integer> numbers = new ArrayList<>();
numbers.add(3);      // int → Integer 자동 박싱
int value = numbers.get(0); // Integer → int 자동 언박싱
```

많은 원소를 다루면 박싱 객체의 메모리와 간접 접근 비용이 생긴다. 가능한 경우 `int[]`, `long[]`가 더 가볍다.

## 4. 형 변환

```java
int x = 10;
long y = x;          // 넓은 타입: 자동 변환
int z = (int) y;     // 좁은 타입: 명시적 변환

char c = 'C';
int alphabetIndex = c - 'A'; // 2
char restored = (char) ('A' + alphabetIndex);
```

문자열과 숫자 변환:

```java
int n = Integer.parseInt("123");
long big = Long.parseLong("12345678900");
String text = String.valueOf(n);
```

## 5. 연산자와 나눗셈

정수끼리 나누면 소수점 아래가 버려진다.

```java
System.out.println(5 / 2);      // 2
System.out.println(5 / 2.0);    // 2.5
```

짝수와 비트:

```java
boolean even = n % 2 == 0;
boolean oddByBit = (n & 1) == 1;
int bit = 1 << index;
boolean selected = (mask & bit) != 0;
```

짧은 회로 평가:

```java
if (index < array.length && array[index] == target) {
    // 왼쪽이 false면 오른쪽을 평가하지 않아 안전
}
```

## 6. 조건문과 반복문

```java
if (score >= 90) {
    grade = 'A';
} else if (score >= 80) {
    grade = 'B';
} else {
    grade = 'C';
}
```

```java
for (int i = 0; i < n; i++) { }

for (int value : array) { }

while (left < right) { }
```

`break`는 현재 반복을 종료하고 `continue`는 다음 반복으로 넘어간다.

## 7. 배열

```java
int[] numbers = new int[n];
int[] initialized = {3, 1, 4};
int[][] grid = new int[rows][cols];

int length = numbers.length;
Arrays.fill(numbers, -1);
Arrays.sort(initialized);
int[] copy = Arrays.copyOf(initialized, initialized.length);
```

객체 배열 정렬:

```java
int[][] intervals = {{3, 5}, {1, 2}, {1, 4}};

Arrays.sort(intervals, (a, b) -> {
    int byStart = Integer.compare(a[0], b[0]);
    if (byStart != 0) return byStart;
    return Integer.compare(a[1], b[1]);
});
```

`a[0] - b[0]`은 오버플로 가능성이 있으므로 `Integer.compare()`를 사용한다.

### `Arrays.asList(int[])`의 실제 타입

다음 코드는 `int[]`의 각 숫자를 `Integer`로 바꿔 주지 않는다.

```java
int[] numbers = {1, 2, 3};

List<int[]> list = Arrays.asList(numbers);

System.out.println(list.size());    // 1
System.out.println(list.get(0)[1]); // 2
```

실제 구조는 숫자 세 개가 들어 있는 리스트가 아니라, `int[]` 배열 하나가 들어 있는 리스트다.

```text
원하는 구조: List<Integer> = [1, 2, 3]
실제 구조:   List<int[]>   = [[1, 2, 3]]
                              └─ int[] 객체 하나
```

`Arrays.asList()`의 타입 매개변수 `T`에는 참조 타입만 사용할 수 있다. `int`는 프리미티브이므로
각 원소의 타입이 될 수 없고, 참조 타입인 `int[]` 전체가 원소 하나로 취급된다.

```java
List<Integer> wrong = Arrays.asList(numbers); // 컴파일 오류
```

반면 `Integer[]`는 각 원소가 참조 타입이므로 `List<Integer>`로 변환할 수 있다.

```java
Integer[] boxedArray = {1, 2, 3};
List<Integer> fixedSizeList = Arrays.asList(boxedArray);
```

단, `Arrays.asList()`가 반환하는 리스트는 크기가 고정되어 있어 `add()`나 `remove()`를 호출하면
`UnsupportedOperationException`이 발생한다. 기존 원소를 `set()`으로 바꾸는 것은 가능하다.

`int[]`를 `List<Integer>`로 변환하려면 각 원소를 명시적으로 박싱한다.

```java
List<Integer> unmodifiableList = Arrays.stream(numbers)
        .boxed()
        .toList();
```

Java 21에서 `Stream.toList()`가 반환하는 리스트는 원소를 추가하거나 삭제할 수 없다.
수정 가능한 `ArrayList`가 필요하면 다음과 같이 수집한다.

```java
// import java.util.stream.Collectors;
List<Integer> mutableList = Arrays.stream(numbers)
        .boxed()
        .collect(Collectors.toCollection(ArrayList::new));
```

스트림 없이 반복문으로 옮겨도 된다.

```java
List<Integer> mutableList = new ArrayList<>();
for (int number : numbers) {
    mutableList.add(number); // int에서 Integer로 자동 박싱
}
```

`List.of(numbers)` 역시 `int[]` 전체를 원소 하나로 취급하므로 같은 점을 주의한다.

## 8. String

`String`은 불변 객체다. 변경 연산은 새 문자열을 만든다.

```java
String s = "algorithm";

int length = s.length();
char first = s.charAt(0);
String part = s.substring(0, 4);   // "algo", 끝 인덱스 미포함
boolean found = s.contains("go");
int index = s.indexOf('r');
String[] pieces = "a,b,c".split(",");
char[] chars = s.toCharArray();
```

문자열 비교는 `==`가 아니라 `equals()`를 사용한다.

```java
if (a.equals(b)) { }
```

사전식 비교:

```java
int order = a.compareTo(b);
```

## 9. StringBuilder

반복문에서 문자열을 이어 붙일 때 사용한다.

```java
StringBuilder sb = new StringBuilder();
sb.append("abc");
sb.append(123);
sb.append('\n');
sb.deleteCharAt(sb.length() - 1);
sb.reverse();
String result = sb.toString();
```

```java
// 피하기: 반복마다 새 String 생성 가능
result += value;
```

## 10. 메서드와 값 전달

Java는 항상 값을 전달한다. 객체를 넘길 때는 참조값의 복사본을 전달한다.

```java
static void changeArray(int[] a) {
    a[0] = 99;       // 같은 배열 객체 변경
}

static void replaceArray(int[] a) {
    a = new int[3];  // 호출자 변수 자체는 바뀌지 않음
}
```

코딩테스트에서는 재귀 상태가 공유 배열을 변경한다면 복구가 필요한지 확인한다.

## 11. 자주 쓰는 Math

```java
Math.min(a, b);
Math.max(a, b);
Math.abs(x);
Math.sqrt(x);
Math.pow(a, b); // double 반환
```

정수 거듭제곱이나 모듈러 거듭제곱은 오차 없는 반복 제곱을 직접 구현하는 편이 안전하다.

## 12. 빠른 입력

### StringTokenizer

```java
BufferedReader br = new BufferedReader(
        new InputStreamReader(System.in)
);
StringTokenizer st = new StringTokenizer(br.readLine());

int n = Integer.parseInt(st.nextToken());
long m = Long.parseLong(st.nextToken());
```

여러 줄에 걸쳐 토큰이 들어오면 토큰 기반 스캐너를 만든다.

```java
static class FastScanner {
    private final BufferedReader br = new BufferedReader(
            new InputStreamReader(System.in)
    );
    private StringTokenizer st;

    String next() throws IOException {
        while (st == null || !st.hasMoreTokens()) {
            st = new StringTokenizer(br.readLine());
        }
        return st.nextToken();
    }

    int nextInt() throws IOException {
        return Integer.parseInt(next());
    }

    long nextLong() throws IOException {
        return Long.parseLong(next());
    }
}
```

`Scanner`는 편하지만 대량 입력에서 느릴 수 있다.

## 13. 출력 모으기

```java
StringBuilder out = new StringBuilder();
for (int value : answer) {
    out.append(value).append('\n');
}
System.out.print(out);
```

반복문마다 `println`을 호출하는 것보다 출력 호출 횟수를 줄일 수 있다.

## 14. Java 실수 체크리스트

```text
- 문자열을 ==로 비교하지 않았는가?
- int 곱셈 뒤 long에 대입하고 있지 않은가?
- 배열 length와 문자열 length()를 구분했는가?
- substring의 끝 인덱스가 미포함임을 확인했는가?
- Arrays.asList(int[])가 List<Integer>가 아님을 아는가?
- 재귀 깊이가 너무 크지 않은가?
- PriorityQueue 순회 결과가 정렬 순서라고 가정하지 않았는가?
```
