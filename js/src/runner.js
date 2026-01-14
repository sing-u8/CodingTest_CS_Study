const path = require("path");

/**
 * Usage:
 *   node src/runner.js platform/baekjoon/B_0000_template.js < ../samples/baekjoon/0000/input.txt
 *
 * npm script:
 *   npm run solve -- platform/baekjoon/B_0000_template.js < ../samples/baekjoon/0000/input.txt
 */
function main() {
  const rel = process.argv[2];
  if (!rel) {
    console.error("Missing <relative-solution-path> (from js/src/).");
    process.exit(1);
  }

  const full = path.resolve(__dirname, rel);
  require(full);
}

main();

