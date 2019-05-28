---
to: "<%= h.src() %>/builds/webpack.common.js"
---
const path = require('path');
const webpackGlobEntries = require('webpack-glob-entries');
const srcDirectoryPath = path.resolve(process.cwd(), "<%= srcDir %>");
const originalEntriesHash = webpackGlobEntries(srcDirectoryPath);
const { pick, values } = require('lodash');
// config files

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
      <% if (language === 'JS') { %>{
            test: /\.js$/,
            exclude: /node_modules/,
            loader: 'babel-loader',
      },<% } %>
      <% if (webpackBasic.includes('css')) { %>{
          test: /\.css$/,
          use: [
            {
              loader: 'style-loader' // Creates style nodes from JS strings
            },
            {
              loader: 'css-loader' // Translates CSS into CommonJS
            }
          ]
      },
      <% } %>
    ]
  }
};