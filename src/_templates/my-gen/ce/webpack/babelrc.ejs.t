---
to : "<%= h.src() + '/.babelrc.js' %>"
---
const env = process.env.BABEL_ENV || process.env.NODE_ENV;

console.log("\n\n****** Inside babelrc. Env is : ", env);

module.exports = {
    presets: [
        ["@babel/preset-env",{
            "useBuiltIns": false,
            "modules" : false
        }],<% if(viewLibrary === 'react') {%>
        ["@babel/preset-react", {
            development: (env === "development" || env === "test") 
        }]<% } %><% if(language === 'ts') {%>
        "@babel/preset-typescript"<% } %>
    ],
    plugins: [
        ["module-resolver", {
            "alias": {
                "@" : "<%='./' + srcDir %>",
                "appConstants" : "<%='./' + srcDir + '/appConstants.' + language %>",
                "appMessages" : "<%='./' + srcDir + '/appMessages.' + language %>",
                "appGlobals" : "<%='./' + srcDir + '/appGlobals.' + language %>",
                "options" : "<%='./' + srcDir + '/options' %>",
                "popup" : "<%='./' + srcDir + '/options' %>",
                "common" : "<%='./' + srcDir + '/common' %>",
                "contentScripts" : "<%='./' + srcDir + '/contentScripts' %>",
                "background" : "<%='./' + srcDir + '/background' %>",
                "assets" : "<%='./' + srcDir + '/assets' %>",
            },
            "extensions": [".js", ".jsx", ".scss", ".css", ".json"]
        }],
        "@babel/plugin-transform-runtime",<% if(language === 'ts') {%>
        "@babel/proposal-class-properties",
        "@babel/proposal-object-rest-spread"<%}%>
        "babel-plugin-lodash"
    ],
    env: {
        "production": {
            "plugins": [
                "transform-react-remove-prop-types"
            ]
        }
    }
}
