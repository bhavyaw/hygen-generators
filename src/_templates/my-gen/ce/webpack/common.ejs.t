---
to: "<%= h.src() %>/webpack/webpack.common.js"
---
const path = require('path');
const webpackGlobEntries = require('webpack-glob-entries');
const srcDirectoryPath = path.join(process.cwd(), "<%= '/' + srcDir + '/**/*.{' + (language === 'js' ? 'js,jsx' : 'ts,tsx') + '}' %>");
const originalEntriesHash = webpackGlobEntries(srcDirectoryPath);
const webpack = require('webpack');
// plugins 
const CopyPlugin = require('copy-webpack-plugin');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const {CleanWebpackPlugin} = require('clean-webpack-plugin');
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin');
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer").BundleAnalyzerPlugin;
const { pick } = require('lodash');
// config files
let mainChunks = pick(originalEntriesHash, [
  '<%= extensionModules.includes('popup') ? "popup" : "" %>',
  '<%= extensionModules.includes('options') ? "options" : "" %>',
  '<%= extensionModules.includes('contentScripts') ? "contentScript1" : "" %>',
  'appGlobals',
  'appMessages',
  'appConstants',
  // other files - add manually
]);

/**
 * Important Notes : 
 * 
 * 1. No need for bundle splitting and separate runtime chunk for / amongst background, popup, options and contentScripts Chunk
 * as they are separate contexts and cannot share any code among them
 * 
 * 2. Only bundle splitting and code splitting related optimization can be done for content scripts which need to loaded on
 * different urls
 * 
 *    2.1 Bundle splitting of shared npm packages
 *    2.2 Code splitting ( or lazy loading ) of modules which can deferred or not initially required
 */

mainChunks[
  'background'
] = "<%=h.src() + '/' + srcDir + '/background/main.' + language %>";

const isProduction = process.env.NODE_ENV === 'production';

console.log(`
Source Directory Path : ${srcDirectoryPath}
Main Chunks : `, JSON.stringify(mainChunks, undefined, 4), 
`Is Production environment : `, isProduction
);

module.exports = {
    entry : mainChunks,
    module : {
      rules : getRulesConfig()
    },
    resolve: {<% if (language === 'ts') {%>
        extensions: ['.ts', '.tsx', '.js', 'json', 'scss', 'css'],<% } %><% if (language === 'js') {%>
        extensions: ['.js', '.jsx', 'json', 'scss', 'css'],<% } %>
    },
    plugins : [
      ...getPluginConfig()
    ]
};


function getRulesConfig() {
  const rules = [
    {
        test:/\.[jt]sx?$/,
        exclude: /node_modules/,
        loader: 'babel-loader',
    },  
    <% if (webpack.includes('css')) { %>{
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
    <% if (webpack.includes('images')) { %>{
      test: /\.svg$/,
      use: "file-loader",
    },
    {
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
    <% if (webpack.includes('fonts')) { %>{
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

function getPluginConfig() {
  const plugins = [
      new webpack.ProgressPlugin(),
      new CleanWebpackPlugin(),
      new CopyPlugin([
          { from: path.join(__dirname, '../<%= srcDir %>/assets') , to: path.join(__dirname, '../dist/assets') },
      ]), 
        new CopyPlugin([
        { from: path.join(__dirname, '../<%= srcDir %>/manifest.json') , to: path.join(__dirname, '../dist/') },
      ]),<% if (extensionModules.includes('popup')) { %>
      new HtmlWebpackPlugin({
        inject: true,
        chunks: ['popup', 'runtime'],
        filename: path.join(__dirname, '../dist/popup.html'),
        template : path.join(__dirname, '../src/popup/popup.html'),
        minify : getHtmlMinificationConfig(),
        chunksSortMode : 'manual'
      }),<%}%>
      <% if (extensionModules.includes('options')) { %>
      new HtmlWebpackPlugin({
        inject: true,
        chunks: ['options', 'runtime'],
        filename: path.join(__dirname, '../dist/options.html'),
        template : path.join(__dirname, '../src/options/options.html'),
        minify : getHtmlMinificationConfig(),
        chunksSortMode : 'manual'
      }),<%}%>
      new LodashModuleReplacementPlugin({
        'array': true,
      })
  ];

  if (process.env.analyzeBundle) {
    plugins.push(new BundleAnalyzerPlugin());
  }
  return plugins;
}

function getHtmlMinificationConfig() {
  return  isProduction
    ? {
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
      }
    : undefined;
}
 