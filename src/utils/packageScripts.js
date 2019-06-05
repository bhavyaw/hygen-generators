

module.exports = {
  webpack : {
    "dev" : "cross-env NODE_ENV=development webpack -w --./webpack/config webpack.dev.js --mode development --progress",
    "start" : "cross-env NODE_ENV=development webpack-dev-server --./webpack/config webpack.dev.js --mode development --progress",
    "build": "cross-env NODE_ENV=production webpack --config ./webpack/webpack.prod.js --mode production --progress", 
  }
};