use std::io::{self, Read};

fn main() {
    let mut input = String::new();
    io::stdin().read_to_string(&mut input).unwrap();
    let mut iter = input.split_ascii_whitespace();
    macro_rules! next {
        ($t:ty) => { iter.next().unwrap().parse::<$t>().unwrap() }
    }

    let a = next!(i64);
    let b = next!(i64);
    println!("{}", a + b);
}
