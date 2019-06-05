---
inject: true
to: "<%= h.src() %>/webpack/webpack.common.js"
after: rules\s*\=\s*\[
skip_if: "sass-loader"
---
<% if (sass) { %>
      {
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
      },<% } %><% if (cssModule === 'normal') { %>
      {
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
          {
            loader : 'sass-loader',
            options: {
                outputStyle: 'expanded',
                sourceMap: true,
                sourceMapContents: true
            }
          }
        ]
      },<%}%>