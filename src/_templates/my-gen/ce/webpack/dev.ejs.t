---
to: "<%= h.src() %>/webpack/webpack.dev.js"
---
const merge = require("webpack-merge");
const common = require("./webpack.common.js");

module.exports = merge(common, {
    devtool : 'cheap-module-eval-source-map',
    output : {
        path: path.resolve(__dirname, '../dist/js'),
        filename: '[name].js'
    },
});

