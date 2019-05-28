---
to: "<%= configFiles.includes('prettier') ? h.src() + '/.prettier' : null %>"
---
{
  "singleQuote": true,
  "trailingComma": "none",
  "tabWidth": 2,
  "printWidth": 90
}