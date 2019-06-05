---
to : "<%= envFileTypes.includes('local') ? ( h.src() + '/config/.env.local' ) : null %>"
---
// Local env file