---
to: "<%= h.src() %>/webpack/webpack.dev.js"
---
const merge = require("webpack-merge");
const common = require("./webpack.common.js");
const path = require('path');

const developmentConfig =  merge(common, {
    devtool : 'source-map',
    output : {
        path: path.resolve(__dirname, '../dist/js'),
        filename: '[name].js'
    },
});

module.exports = developmentConfig;
