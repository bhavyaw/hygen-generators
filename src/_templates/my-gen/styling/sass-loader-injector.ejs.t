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
    },<% } %><% if (typeof cssModule !== undefined) { %>
    {
    exclude: /node_modules/, 
    test: /\.module\.scss$/,
    use: [
      'style-loader',
      {
          loader: 'css-loader', // Translates CSS into CommonJS
          options: {
            importLoaders: 1,
            modules: {
              localIdentName: '[name]__[local]',
              context : path.resolve(__dirname, '../src')
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