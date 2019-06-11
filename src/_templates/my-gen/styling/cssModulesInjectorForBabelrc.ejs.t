---
inject: true
to: "<%= h.src() %>/.babelrc.js"
after: plugins\s*\:\s*\[
skip_if: "react-css-modules"
---
<% if (cssModule === 'babel') { %>
    ["react-css-modules", {
      "webpackHotModuleReloading": true,
        "generateScopedName": "[name]_[local]_[hash:base64:5]",
        "filetypes": {
          ".module.scss": {
              "syntax": "postcss-scss",
                "plugins" : [
                  ["postcss-import-sync2", {
                    "path": ["src/assets/styles"]
                  }],
                  "postcss-nested"
                ]
          }
        }
    }],<%}%>