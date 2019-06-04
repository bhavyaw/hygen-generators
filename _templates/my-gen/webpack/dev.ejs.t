---
to: "<%= h.src() %>/webpack/webpack.dev.js"
---
const merge = require("webpack-merge");
const common = require("./webpack.common.js");

module.exports = merge(common, {
    devtool : 'cheap-module-eval-source-map',<% if (projectType.includes('chromeExtension')) { %>
    output : {
        path: path.resolve(__dirname, '../dist/js'),
        filename: '[name].js'
    },<% } %><% if (!projectType.includes('chromeExtension')) { %>
    output : {
        path: path.resolve(__dirname, '../dist'),
        filename: '[name].[chunkhash].js'
    },<% } %>
});

