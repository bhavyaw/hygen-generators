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
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
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
        extensions: ['.ts', '.tsx', '.js', '.json', '.scss', '.css'],<% } %><% if (language === 'js') {%>
        extensions: ['.js', '.jsx', '.json', '.scss', '.css'],<% } %>
    },
    plugins : [
      ...getPluginConfig()
    ],
    optimization : getOptimizationConfig()
};


function getRulesConfig() {
  const rules = [
    {
      test:/\.[jt]sx?$/,
      exclude: /node_modules/,
      loader: 'babel-loader',
    },<% if (cssModule === 'normal') { %> 
    {
      test: /\.module\.<%= sass ? "s?" : "" %>css$/,
      exclude: /node_modules/, 
      sideEffects : true,
      use: [
        isProduction ? MiniCssExtractPlugin.loader :  'style-loader', // Creates style nodes from JS strings        
        {
            loader: 'css-loader', // Translates CSS into CommonJS
            options: {
              importLoaders : <%= sass ? 2 : 0 %>,
              modules: {
                localIdentName: '[name]__[local]',
                context : path.resolve(__dirname, '../src')
              },
              sourceMap: !isProduction,
              localsConvention: 'camelCase',
              url : false
            }
        },<% if(sass) {%>
        'resolve-url-loader',
        {
          loader : 'sass-loader',
          options: {
              outputStyle: isProduction ? 'compressed' : 'expanded',
              sourceMap: !isProduction,
          }
        }<%}%>
      ]
    },<%}%><% if (webpack.css || sass) {%>
    {
      test: /^((?!module).)*\.<%= sass ? "s?" : "" %>css$/,
      exclude: /\.module\.<%= sass ? "s?" : "" %>css$/, 
      sideEffects : true,
      use: [
        isProduction ? MiniCssExtractPlugin.loader :  'style-loader', // Creates style nodes from JS strings
        {
          loader: 'css-loader', // Translates CSS into CommonJS
          options : {
            url : false,
            importLoaders : <%= sass ? 2 : 0 %>,
          }
        },
        <% if(sass) {%>
        'resolve-url-loader',
        {
          loader : 'sass-loader',
          options: {
              outputStyle: isProduction ? 'compressed' : 'expanded',
              sourceMap: !isProduction,
          }
        }<%}%>
      ]
    },<%}%><% if (webpack.includes('images')) { %>
    {
      test: /\.svg$/,
      use: "file-loader",
    },
    {
      test: /\.(png|jpe?g|gif)$/,
      //exclude: path.resolve(__dirname, "../src/assets/images/source"),
      use: [
          {
            loader: "url-loader",
            options: {
                limit: 8192,
                name: "name].[ext]",
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
      new CopyPlugin([
          { from: path.join(__dirname, '../<%= srcDir %>/assets') , to: path.join(__dirname, '../dist/assets') },
      ]), 
      new CopyPlugin([
        { from: path.join(__dirname, '../<%= srcDir %>/manifest.json') , to: path.join(__dirname, '../dist/') },
      ]),<% if (extensionModules.includes('popup')) { %>
      new HtmlWebpackPlugin({
        title : "<%= appName %>",
        inject: true,
        chunks: [
          'common~background~popup',
          'vendors~options~popup',
          'popup'
        ],
        filename: path.join(__dirname, '../dist/popup.html'),
        template : path.join(__dirname, '../src/popup/popup.html'),
        minify : getHtmlMinificationConfig(),
        chunksSortMode : 'manual'
      }),<%}%><% if (extensionModules.includes('options')) { %>
      new HtmlWebpackPlugin({
        title : "<%= appName %>",
        inject: true,
        chunks: [
          'vendors~background~options',
          'vendors~options~popup',
          'options'
        ],
        filename: path.join(__dirname, '../dist/options.html'),
        template : path.join(__dirname, '../src/options/options.html'),
        minify : getHtmlMinificationConfig(),
        chunksSortMode : 'manual'
      }),<%}%>
      new HtmlWebpackPlugin({
        title : "<%= appName %>",
        inject: true,
        chunks: [
          'common~background~popup',
          'vendors~background~options',
          'background'
        ],
        filename: path.join(__dirname, '../dist/background.html'),
        template : path.join(__dirname, '../src/background/background.html'),
        minify : getHtmlMinificationConfig(),
        chunksSortMode : 'manual'
      }),
      new LodashModuleReplacementPlugin({
        'array': true,
      }),
      new CleanWebpackPlugin()
  ];

  if (process.env.analyzeBundle) {
    plugins.push(new BundleAnalyzerPlugin());
  }
  return plugins;
}

function getOptimizationConfig() {
  return {
    splitChunks: {
      cacheGroups: {
          vendors: {
            test: /[\\/]node_modules[\\/]/i,
            minSize : 0,
            minChunks: 2,
            chunks: 'all',
            priority : 20
          },
          common : {
            minSize : 0,
            minChunks: 2,
            chunks: 'all',
            reuseExistingChunk: true,
            priority: 10,
          }
      }
    },
    sideEffects: true
  }
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
 