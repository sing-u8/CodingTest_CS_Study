const path = require("path");

/**
 * Usage:
 *   node src/runner.js platform/leetcode/LC_0000_template.js
 *
 * npm script:
 *   npm run solve -- platform/leetcode/LC_0000_template.js
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

