---
to: "<%= h.src() %>/webpack/webpack.prod.js"
---
const webpack = require('webpack');
const merge = require("webpack-merge");
const common = require("./webpack.common.js");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const TerserPlugin = require('terser-webpack-plugin');
const path = require('path');

module.exports = merge(common, {
  // sourceMap : 'source-map', <-- in case you need to debug prod app just uncomment this line
  mode: "production",
  output : {
    filename: '[name].js',
    path: path.join(__dirname, '../dist/js'),
   // publicPath: 'https://cdn.example.com/assets/[hash]/'
  },
   optimization: {
    minimizer: [
      new TerserPlugin({
        parallel : true,
        sourceMap: true,
        terserOptions : {
          module : true,
          toplevel : true,
          keep_classnames  : false,
          compress: {
            warnings: true,
            // drop_console: true,
            unused: true,
            keep_fargs : false,
            toplevel : true
          }
        }
      })
    ]
  },
  plugins : [
    // Avoid publishing files when compilation fails
    new webpack.NoEmitOnErrorsPlugin(), 
    new webpack.HashedModuleIdsPlugin(),<% if(webpack.includes('css')) {%>
    new MiniCssExtractPlugin({
        filename: "css/app.[contenthash].min.css",
        allChunks: true
    }),<%}%>
  ]
});

