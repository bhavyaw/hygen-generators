---
to: "<%=  linter !== 'none' ? h.src() + (linter === 'eslint' ? '/.eslintrc' : '/tslint.json') : null %>"
---
// tslint or eslint file contents below