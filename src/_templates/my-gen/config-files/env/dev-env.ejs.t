---
to : "<%= envFileTypes.includes('development') ? ( h.src() + '/config/.env.development' ) : null %>"
---
// development env file