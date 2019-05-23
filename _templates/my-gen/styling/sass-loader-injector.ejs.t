---
inject: true
to: "<%= h.src() %>/config/webpack.common.js"
after: rules\s*\:\s*\[
---
<% if (styling.includes('sass')) { %>{
  test: /\.scss$/,
  exclude: /\.module\.scss$/,
  use: [
    'style-loader',
    {
      loader: 'css-loader',
      options: {
        modules: false,
        sourceMap: true
      }
    },
    'sass-loader'
  ]
},<% } %>
<% if (styling.includes('cssModules')) { %>{
  exclude: /node_modules/, 
  test: /\.module\.scss$/,
  use: [
    'style-loader',
    {
      loader: 'css-loader', // Translates CSS into CommonJS
      options: {
        modules: true,
        localIdentName: '[name]__[local]___[hash:base64:5]',
        sourceMaps: true,
        camelCase: true
      }
    },
    'sass-loader'
  ]
 }<% } %>