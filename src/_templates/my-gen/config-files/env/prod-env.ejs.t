---
to : "<%= envFileTypes.includes('production') ? ( h.src() + '/config/.env.production' ) : null %>"
---
// Production env file