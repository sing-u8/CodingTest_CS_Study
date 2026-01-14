const fs = require("fs");

function readAll() {
  return fs.readFileSync(0, "utf8").trimEnd();
}

function tokens() {
  const s = readAll();
  if (!s) return [];
  return s.split(/\s+/);
}

module.exports = { readAll, tokens };

