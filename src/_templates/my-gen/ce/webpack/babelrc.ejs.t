---
to : "<%= h.src() + '/.babelrc.js' %>"
---
const env = process.env.BABEL_ENV || process.env.NODE_ENV;<% if(cssModule === 'babel' && viewLibrary === 'react') {%>
const path = require('path');
const context = path.resolve(__dirname, './src');<%}%>

console.log("\n\n****** Inside babelrc. Env is : ", env);

const babelOptions = {
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
    plugins: [<% if(cssModule === 'babel' && viewLibrary === 'react') {%>
        [
            'babel-plugin-react-css-modules',
            {
                context: context,
                exclude: /node_modules/, 
                generateScopedName: generateClassNames,
                filetypes: {
                '.scss': {
                    syntax: 'postcss-scss',
                    plugins: [
                    ['postcss-import-sync2', { resolve: postCssImportResolver }],
                    'postcss-nested']
                }
                },
                exclude: 'node_modules',
                webpackHotModuleReloading: true,
                handleMissingStyleName: 'warn',
                autoResolveMultipleImports: true
            }
        ],<%}%>
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
        "babel-plugin-lodash",
        "babel-plugin-syntax-dynamic-import",
        "@babel/plugin-proposal-class-properties"
    ]
};

module.exports = babelOptions;

if (env === "development") {
    babelOptions.plugins.push("@babel/plugin-transform-react-jsx");
} else if (env === 'production') {
    babelOptions.plugins.push("transform-react-remove-prop-types");
}

function postCssImportResolver(id, basedir, importOptions) {
  let nextId = id;

  if (id.substr(0, 2) === './') {
    nextId = id.replace('./', '');
  }

  if (nextId[0] !== '_') {
    nextId = `_${nextId}`;
  }

  if (nextId.indexOf('.scss') === -1) {
    nextId = `${nextId}.scss`;
  }

  return path.resolve(basedir, nextId);
}

function generateClassNames(localName, resourcePath) {
  const fileName = path.basename(resourcePath, '.scss');
  return `${fileName}__${localName}`;
}
