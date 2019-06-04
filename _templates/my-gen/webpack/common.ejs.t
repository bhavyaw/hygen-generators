---
to: "<%= h.src() %>/webpack/webpack.common.js"
---
const path = require('path');
const webpackGlobEntries = require('webpack-glob-entries');
const srcDirectoryPath = path.resolve(process.cwd(), "<%= srcDir %>/**/*.{<%= language === 'JS' ? 'js,jsx' : 'ts,tsx' %>}");
const originalEntriesHash = webpackGlobEntries(srcDirectoryPath);
// plugins 
const CopyPlugin = require('copy-webpack-plugin');
const { pick, values } = require('lodash');
// config files
<% if (!projectType.includes('chromeExtension')) { %>
let mainChunks = pick(originalEntriesHash, [
  'main-chunk-1',
  'main-chunk-2',
]);<%}%>
<% if (projectType.includes('chromeExtension')) { %>
let mainChunks = pick(originalEntriesHash, [
  'popup',
  'options',
  'appConfig',
  'appMessages',
  'appConstants',
  // other files - add manually
]);<%}%>

mainChunks[
  'background'
] = "<%=h.src() + '/background/main.' + (language === 'JS' ? 'js' : 'ts' ) %>";

console.log(`
  Source Directory Path : ${srcDirectoryPath}
  Main Chunks : ${mainChunks}
`);

module.exports = function(env) {
  const webpackConfig = {};
  const rules = getRulesConfig(env);

  Object.assign(webpackConfig, {
      devtool : 'eval-source-map',
      entry : mainChunks,<% if (!projectType.includes('chromeExtension')) { %>
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
      },<%}%>
      module : {
        rules
      },
      resolve: {<% if (language === 'TS') {%>
          extensions: ['.ts', '.tsx', '.js'],<% } %><% if (language === 'JS') {%>
          extensions: ['.js', '.jsx'],<% } %>
      },<% if (!projectType.includes('chromeExtension')) { %>
      optimization : getOptimizationConfig(env);
      <%}%> 
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
      }<% } %>
    ];

    return rules;
}

function getPluginConfig(env) {
  const plugins = [
      new webpack.ProgressPlugin(),
      new CleanWebpackPlugin(), <% if (projectType.includes('chromeExtension')) { %>
      new CopyPlugin([
        { from: (srcDir + '/assets') , to: 'dest/assets' },
        // { from: (srcDir + '/assets) , to: 'dest/assets' },
      ], {
      // ignore : [] // globs
      }),<%}%><% if (!projectType.includes('chromeExtension')) { %>
      new CopyPlugin([
          { from: path.join(__dirname, '../src/assets') , to: path.join(__dirname, '../dist/assets' },
      ]), 
      new HtmlWebpackPlugin({
        inject: false,
        chunks: ['popup'],
        filename: path.join(__dirname, '../dist/popup.html'),
        template : path.join(__dirname, '../src/popup/popup.html')
        ...getHtmlMinificationConfig(env.production),
      }),
      new HtmlWebpackPlugin({
        inject: false,
        chunks: ['options'],
        filename: path.join(__dirname, '../dist/options.html'),
        template : path.join(__dirname, '../src/options/options.html')
        ...getHtmlMinificationConfig(env.production),
      }),<%}%>
     // in non-chrome extension apps we usually have a single index.html file
     <% if (!projectType.includes('chromeExtension')) { %>
      new HtmlWebpackPlugin({
        inject: true,
        chunks: ['index'],
        filename: path.join(__dirname, '../dist/index.html'),
        ...getHtmlMinificationConfig(env.production),
      }),<%}%><% if (projectType.includes('chromeExtension')) { %>
      new HtmlWebpackPlugin({
        inject: true,
        chunks: ['popup'],
        filename: path.join(__dirname, '../dist/popup.html'),
        ...getHtmlMinificationConfig(env.production),
      }),
      new HtmlWebpackPlugin({
        inject: true,
        chunks: ['options'],
        filename: path.join(__dirname, '../dist/options.html'),
        ...getHtmlMinificationConfig(env.production),
      }),
     <% } %>
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
       chunks: 'all',
       maxInitialRequests: Infinity,
       minSize: 0,
        cacheGroups: {
            vendor : {
                test: /[\\/]node_modules[\\/]/,
                name(module) {
                  // get the name. E.g. node_modules/packageName/not/this/part.js
                  // or node_modules/packageName
                  const packageName = module.context.match(/[\\/]node_modules[\\/](.*?)([\\/]|$)/)[1];

                  // npm package names are URL-safe, but some servers don't like @ symbols
                  return `npm.${packageName.replace('@', '')}`;
                }
            }
        }
    }
  };

  return optimation;
}

function getHtmlMinificationConfig(production) {
  return  production
    ? {
        minify: {
          removeComments: true,
          collapseWhitespace: true,
          removeRedundantAttributes: true,
          useShortDoctype: true,
          removeEmptyAttributes: true,
          removeStyleLinkTypeAttributes: true,
          keepClosingSlash: true,
          minifyJS: true,
          minifyCSS: true,
          minifyURLs: true,
        },
      }
    : {};
}
 