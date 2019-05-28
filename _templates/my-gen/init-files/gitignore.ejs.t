---
to: "<%= configFiles.includes('gitignore') ? h.src() + '/.gitignore' : null %>"
---
node_modules
*.log
dist/

### Environment Files
environments/
*.env