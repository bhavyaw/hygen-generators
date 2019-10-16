const {addNewPackage, packageJson, copyFiles, hygenConfig} = require('../../../utils');
const packageScripts = require('../../../utils/packageScripts');
const get = require("lodash/get");
const makeDir = require('make-dir');
const path = require('path');
const writePackage = require('write-pkg');


module.exports = {
  prompt : async({prompter, args}) => {
    let promptAnswers =  {};

    // common to all generators
    const hygenConfigPrompt = {
      type : 'confirm',
      name : 'hygenConfig',
      message : 'Do you want to add Hygen config',
    };
    
    const languageUsedPrompt = {
      type : 'select',
      name : 'language',
      message : 'Please select the Project Type',
      choices : [
        {name : 'js', message : 'JavaScript', value : true},
        {name : 'ts', message : 'Typescript', value : true}
      ]
    };

    const viewLibrary = {
      type : 'select',
      name : 'viewLibrary',
      message : 'Please select a view library for Popup and options page',
      choices : [
        {name : 'none', message : 'none', value : true},
        {name : 'react', message : 'react', value : true},
        {name : 'vue', message : 'vue', value : true}
      ]
    };

    // common to all generators
    const srcDirPathPrompt = {
      type : 'input',
      name: 'srcDir',
      message: '\nPlease Enter your source directory path. \nNote : Just the name or path from project root. No delimiters in the beginning or end... \n',
      hint : 'For eg : src, codebase etc',
      initial : 'src'
    };

    const extensionModules = {
      type : 'multiselect',
      name : 'extensionModules',
      message : 'Please select the modules you require for your extension',
      choices : [
        {name : 'popup', message : 'Popup', value : true},
        {name : 'options', message : 'Options', value : true},
        {name : 'contentScripts', message : "Content Scripts", value : true},
        {name : 'webAccessScript', message : 'Web Access Scripts', value : true},
        {name : 'customMessenger', message : 'Custom Extension Messenger', value : true},
        {name : 'persistentBackground', message : 'Persistent Background Script ?', value : true},
      ]
    };


    const webpackRequirements = {
      type : 'multiselect',
      name: 'webpack',
      message: '\nPlease select your webpack requirements ( using spacebar ): \n',
      choices: [
        { name : 'images', message : 'Images Loader', value : true},
        { name : 'fonts', message : 'Fonts Loader', value : true},
        { name : 'css', message : 'CSS', value : true},
      ]
    };

    const stylingRequirementsPrompt = {
      type : "confirm",
      name : "sass",
      message : "Do you want to use sass preprocessor for styling ?",
    };

    const cssModulesType = {
      type : 'select',
      name : 'cssModule',
      message : 'Select the css module type',
      choices : [
        {name : 'none', message : 'No CSS Modules'},
        { name : 'normal', message : 'Normal CSS Modules'},
        { name : 'babel', message : 'Babel Plugin react css modules'}
      ]
    };

  
    const initialPrompts = [
      hygenConfigPrompt,
      languageUsedPrompt, 
      viewLibrary,
      srcDirPathPrompt, 
      extensionModules,
      webpackRequirements,
      stylingRequirementsPrompt,
      cssModulesType
    ];
  
    promptAnswers = await prompter.prompt(initialPrompts);
    // const absoluteSrcDirectoryPath = path.resolve(promptAnswers.srcDir);
    if (promptAnswers.extensionModules.includes('options')) {
      Object.assign(promptAnswers, await prompter.prompt({
        type : 'confirm',
        name : 'embeddedOptionsPage',
        message : 'Do you need a embedded options page ?'
      }));
    }
  
    console.log(`Prompt answers : `, promptAnswers);
    
    Object.assign(promptAnswers, {
      appName : packageJson.name || "",
      description : packageJson.description || "",
      appVersion : packageJson.version || ""
      // src : absoluteSrcDirectoryPath
    });
    console.log(`Prompt Answers for chrome extension generator are : `, promptAnswers);
    await addConfigToPackageJson(promptAnswers);
    await executeCommands(promptAnswers);
    return promptAnswers;
  }
};

async function addConfigToPackageJson (promptAnswers) {
  console.log("Webpack generator : Writing to package.json file!!!");
  const jsonToAppend = {};
  const existingScripts = get(packageJson, "scripts") || {};
  const webpackScripts = get(packageScripts, "webpack");
  const newScripts = Object.assign({}, existingScripts, webpackScripts);
  const browserslist = {
    "development": [
      "last 10 Chrome versions"
    ],
    "production": [
      "last 20 Chrome versions"
    ]
  };
  jsonToAppend["scripts"] = newScripts;
  jsonToAppend["browserslist"] = browserslist;
  // to enable tree shaking
  jsonToAppend["sideEffects"] = [
    "*.css"
  ];

  if (promptAnswers.sass) {
    jsonToAppend["sideEffects"].push(".scss", ".sass");
  }
  
  Object.assign(packageJson, jsonToAppend);
  // console.log("inside addConfigToPackageJson() : ", jsonToAppend);
  // writing to package JSON 
  await writePackage(packageJson);
}

// @priority high
//TODO - instead of this create separate package.json and just run yarn command - more customizable
async function executeCommands(promptAnswers) {
  const assetsPath = path.normalize(process.cwd() + '/src/assets');
  console.log(`Assets Path is  : `, assetsPath);
  // creating assets directory
  await makeDir(assetsPath);
  // copy assets
  await copyFiles(
    path.normalize(path.resolve(hygenConfig.templates + '/../assets/ce')),
    path.normalize(path.resolve(promptAnswers.srcDir + '/assets'))
  );
  // npm packages
  await addNodePackages(promptAnswers);
}

// @priority medium
//TODO - it would be much better to create a package json template or injection of dependencies and call yarn post that
async function addNodePackages(promptAnswers) {
  // lodash
  await addNewPackage('lodash');
  // webpack core
  await addNewPackage('webpack webpack-cli webpack-dev-server webpack-merge cross-env webpack-glob-entries mini-css-extract-plugin', "dev");
  // webpack plugins
  await addNewPackage(`
    clean-webpack-plugin 
    webpack-bundle-analyzer 
    html-webpack-plugin@next 
    copy-webpack-plugin 
    lodash-webpack-plugin 
    terser-webpack-plugin
    optimize-css-assets-webpack-plugin
  `, "dev");

  if (promptAnswers.webpack.includes('CSS')) {
    await addNewPackage('css-loader style-loader mini-css-extract-plugin', "dev");
  }

  if (promptAnswers.webpack.includes('images')) {
    await addNewPackage('url-loader file-loader', "dev");
  }

  if (promptAnswers.webpack.includes('fonts')) {
    await addNewPackage('url-loader', "dev");
  }

  // babel loaders
  if (promptAnswers.language === 'js') {
    await addNewPackage('@babel/core @babel/cli @babel/preset-env babel-loader @babel/runtime', "dev");
    // babel plugins
    await addNewPackage(`
      @babel/plugin-transform-runtime 
      babel-plugin-module-resolver 
      babel-plugin-lodash 
      babel-plugin-syntax-dynamic-import
      @babel/plugin-transform-react-jsx`, "dev");
  }

  if (promptAnswers.language === 'ts') {
    await addEventListener('@babel/preset-typescript @babel/plugin-proposal-class-properties @babel/proposal-class-properties @babel/proposal-object-rest-spread', "dev");
  }

  if (promptAnswers.viewLibrary === 'react') {
    await addNewPackage('@babel/preset-react babel-plugin-transform-react-remove-prop-types', "dev");
    await addNewPackage('prop-types react react-dom');
  }

  console.log('inside executeCommands() for styling generator');
  if (promptAnswers.sass) {
    await addNewPackage("sass-loader resolve-url-loader node-sass", "dev");
  }

  if (promptAnswers.cssModule === 'normal') {
    await addNewPackage("sass-loader css-loader style-loader", "dev");
  }

  if (promptAnswers.cssModule === 'babel' && promptAnswers.viewLibrary === 'react') {
    await addNewPackage('babel-plugin-react-css-modules postcss-scss postcss-nested postcss-import-sync2', "dev");
  } else if (promptAnswers.viewLibrary !== 'react') {
    console.error(`Babel react css modules work only with react...use normal css modules otherwise`);
  }
}
