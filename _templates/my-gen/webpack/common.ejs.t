---
to: "<%= h.src() %>/webpack/webpack.common.js"
---
const path = require('path');
const webpackGlobEntries = require('webpack-glob-entries');
const srcDirectoryPath = path.resolve(process.cwd(), "<%= srcDir %>");
const originalEntriesHash = webpackGlobEntries(srcDirectoryPath);
// plugins 
const CopyPlugin = require('copy-webpack-plugin');
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

module.exports = function(env) {
  const webpackConfig = {};
  const rules = getRulesConfig(env);
  const optimizations = getOptimizationConfig(env);

  Object.assign(webpackConfig, {
      devtool : 'eval-source-map',
      entry : mainChunks,
      <% if (!projectType.includes('chromeExtension')) { %>
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
      },<% } %>
      module : {
        rules
      },
      resolve: {
        <% if (language === 'TS') {%>
          extensions: ['.ts', '.tsx', '.js'],
        <% } %>
        <% if (language === 'JS') {%>
          extensions: ['.js', '.jsx'],
        <% } %>
      },
      optimization
  });
  // plugins
  const plugins = getPluginConfig(env);
  Object.assign(webpackConfig, {plugins})

  return webpackConfig;
}

function getRulesConfig(env) {
  const rules = [
      {
          test:/\.[jt]sx?$/,
          exclude: /node_modules/,
          loader: 'babel-loader',
      },  
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
      },<% } %>
      <% if (webpackBasic.includes('images')) { %>{
        test: /\.svg$/,
        use: "file-loader",
      },<% } %>
      <% if (webpackBasic.includes('images')) { %>{
          test: /\.(png|jpg|jpeg|gif)$/,
          //exclude: path.resolve(__dirname, "../src/assets/images/source"),
          use: [
              {
                  loader: "url-loader",
                  options: {
                      limit: 8192,
                      name: "images/[path][name].[ext]?[hash]",
                      //publicPath: ""
                  }
              }
          ]
      },<% } %>
      <% if (webpackBasic.includes('fonts')) { %>{
          test: /\.(woff|woff2|ttf|eot)(\?v=\d+\.\d+\.\d+)?$/,
          use: {
              loader: "url-loader",
              options: {
                  limit: 8192,
                  name: "fonts/[name].[ext]?[hash]"
                  // publicPath: "../", // Take the directory into account
              }
          }
      },<% } %>

    ];

    return rules;
}



function getPluginConfig(env) {
  const plugins = [
      new CopyPlugin([
        { from: '<%= srcDir %>/assets' , to: 'dest/assets' },
        // { from: '<%= srcDir %>/assets' , to: 'dest/assets' },
      ], {
      // ignore : [] // globs
      }),
  ];

  if (env.analyzeBundle) {
    plugins.push(new BundleAnalyzerPlugin());
  }

  return plugins;
}

function getOptimizationConfig(env) {
  const optimization = {
    runtimeChunk: 'single',
    splitChunks: {
        cacheGroups: {
            node_vendors : {
                test: /[\\/]node_modules[\\/]/,
                name: 'vendors',
                enforce: true,
                chunks: 'all'
            }
        }
    }
  };

  return optimation;
}