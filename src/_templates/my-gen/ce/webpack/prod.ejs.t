---
to: "<%= h.src() %>/webpack/webpack.prod.js"
---
const merge = require("webpack-merge");
const common = require("./webpack.common.js");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const path = require('path');

module.exports = merge(common, {
  mode: "production",
  output : {
    filename: '[name].js',
    path: path.join(__dirname, '../dist/js'),
   // publicPath: 'https://cdn.example.com/assets/[hash]/'
  },
  plugins : [<% if(webpack.includes('css')) {%>
    new MiniCssExtractPlugin({
        filename: "css/app.[contenthash].min.css",
        allChunks: true
    }),<%}%>
    new webpack.HashedModuleIdsPlugin()
  ]
});

