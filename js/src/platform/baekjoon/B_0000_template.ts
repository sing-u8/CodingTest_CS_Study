import fs from "fs";

// samples/baekjoon/0000/input.txt: "1 2"
const input = fs.readFileSync(0, "utf8").trim();
const [a, b] = input.split(/\s+/).map(Number);
console.log(a + b);
