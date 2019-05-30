---
to: "<%= h.src() %>/webpack/webpack.dev.js"
---
const merge = require("webpack-merge");
const common = require("./webpack.common.js");

module.exports = merge(common, {
    devtool : 'eval-source-map',
    devServer: {
      port: 9000,
      contentBase: path.join(__dirname, "dist"),
      clientLogLevel: 'none',   
      watchContentBase: true,
      compress: true,
      open: true,
      hot : true,
      stats: 'errors-only',
      overlay: true
    }
});

