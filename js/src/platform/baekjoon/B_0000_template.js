const { tokens } = require("../../lib/io");

// samples/baekjoon/0000/input.txt: "1 2"
const t = tokens();
const a = Number(t[0]);
const b = Number(t[1]);
console.log(a + b);

