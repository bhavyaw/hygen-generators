---
to: "<%= h.src() %>/config/webpack.common.js"
---
const path = require('path');
const webpackGlobEntries = require('webpack-glob-entries');
const srcDirectoryPath = path.resolve(process.cwd(), "<%= srcDir %>");
const originalEntriesHash = webpackGlobEntries(srcDirectoryPath);
const { pick, values } = require('lodash');

const mainChunks = pick(originalEntriesHash, [
  'main-chunk-1',
  'main-chunk-2'
]);

console.log(`
  Source Directory Path : ${srcDirectoryPath}
  Main Chunks : ${mainChunks}
`);

module.exports = {
  entry : mainChunks,
  module : {
    rules : [

    ]
  }
};

