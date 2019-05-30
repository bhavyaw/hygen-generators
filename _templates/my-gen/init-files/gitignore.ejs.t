---
to: "<%= configFiles.includes('gitignore') ? h.src() + '/.gitignore' : null %>"
---
node_modules
*.log
dist/

### Environment Files
/config
*.env

# production
/build

# misc
.DS_Store
.env.local
.env.development
.env.test.local
.env.production

npm-debug.log*
yarn-debug.log*
yarn-error.log*