---
to: "<%=  linter === 'eslint' ? ( h.src() + '/.eslintignore' )  : null %>"
---
node_modules/*
dist/*
config/*
build/* 