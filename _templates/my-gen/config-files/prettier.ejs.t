---
to: "<%= h.src() %>/.prettier"
sh : "npx prettier || yarn add -D prettier"
---
{
  "singleQuote": true,
  "trailingComma": "none",
  "tabWidth": 2,
  "printWidth": 90
}