---
inject: true
to: "<%= h.src() %>/webpack/webpack.common.js"
after: sass-injection-hook
skip_if: sass-loader
---
<% if (sass) { %>{
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
          importLoader: 1,
          modules: {
            localIdentName: '[name]__[local]___[hash:base64:5]',
          },
          sourceMap: true,
          localsConvention: 'camelCase'
        }
      },<% if (sass) { %>
      {
        loader : 'sass-loader',
        options: {
            outputStyle: 'expanded',
            sourceMap: true,
            sourceMapContents: true
        }
      }<%}%>
    ]
  },<%}%>