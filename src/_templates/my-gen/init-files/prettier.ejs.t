---
to: "<%= configFiles.includes('prettier') ? h.src() + '/.prettierrc' : null %>"
---
{
  "singleQuote": true,
  "trailingComma": "none",
  "tabWidth": 2,
  "printWidth": 90
}