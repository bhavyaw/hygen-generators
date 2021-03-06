---
inject: true
to: "<%= envFileTypes.length ? h.src() + '/builds/webpack.common.js' : null %>"
after: \/\/\sconfig\sfile
skip_if : require\s*\(['"]dotenv['"]\)
---
const dotenv = require('dotenv');
const configFilePath = path.resolve(__dirname, `../config/.env.${process.env.NODE_ENV`}`);
dotenv.config({ path: configFilePath});