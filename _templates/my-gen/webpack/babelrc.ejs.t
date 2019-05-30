---
to : "<%= (language === 'JS' && webpackBasic.es6 ) ? h.src() + '/.babelrc.js' : null %>"
---

const env = process.env.BABEL_ENV || process.env.NODE_ENV;

module.exports = {
    presets: [
         ["@babel/preset-env",{
            "useBuiltIns": "usage",
         }],
        <% if(projectType.includes('react')) {%>
            ["@babel/preset-react", {
                 { development: env === "development" || env === "test" },
            }]
        <% } %>

        <% if(language === 'TS') {%>
            "@babel/preset-typescript"
        <% } %>
    ],
    plugins: [
        "transform-runtime",
        <% if(language === 'TS') {%>
        "@babel/proposal-class-properties",
        "@babel/proposal-object-rest-spread"
        <% } %>
    ],
    env: {
        "production": {
            "plugins": [
                "transform-react-remove-prop-types"
            ]
        }
    }
}
