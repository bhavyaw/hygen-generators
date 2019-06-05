---
inject: true
to: "<%= h.src() %>/.babelrc.js"
after: plugins\s*\:\s*\[
skip_if: "module-resolver"
---
<% if (cssModule === 'babel') { %>
    ["module-resolver", {
      "alias": {},
      "extensions": [".js", ".jsx", ".scss", ".css", ".json"]
    }],
    ["react-css-modules", {
      "webpackHotModuleReloading": true,
      "filetypes": {
        "generateScopedName": "[name]_[local]_[hash:base64:5]",
          "filetypes": {
            ".module.scss": {
                "syntax": "postcss-scss",
                plugins : [
                  ["postcss-import-sync2", {
                    "path": ["src/assets/styles"]
                  }],
                  "postcss-nested"
                ]
            }
        }
      }
    }],<%}%>