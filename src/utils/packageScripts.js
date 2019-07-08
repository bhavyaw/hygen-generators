

module.exports = {
  webpack : {
    "dev" : "cross-env NODE_ENV=development npx webpack -w --config ./webpack/webpack.dev.js --mode development --progress",
    "start" : "cross-env NODE_ENV=development npx webpack-dev-server --config ./webpack/webpack.dev.js --mode development --progress",
    "build": "cross-env NODE_ENV=production npx webpack --config ./webpack/webpack.prod.js --mode production --progress", 
  },
  eslint : {
    "lint-all": "eslint \"./**/*{.js,.jsx}\"",
    "lint:fix": "eslint --fix",
    "watch:lint-all": "onchange --await-write-finish 1000 \"./**/*{.js,.jsx}\" -- yarn lint",
    "watch:lint-fix": "onchange  --await-write-finish 1000 \"./**/*{.js,.jsx}\" -- yarn lint:fix \"{{changed}}\"",
    "watch:echo": "onchange --await-write-finish 1000 \"./**/*.js\" -- echo \"{{changed}}\""
  }
};