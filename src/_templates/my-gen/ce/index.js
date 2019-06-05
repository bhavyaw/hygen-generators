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
    const languageUsedPrompt = {
      type : 'select',
      name : 'language',
      message : 'Please select the Project Type',
      choices : [
        {name : 'JS', message : 'JavaScript', value : true},
        {name : 'TS', message : 'Typescript', value : true}
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
      message: '\nPlease Enter your source directory path \n',
      hint : "For eg : '../'   |   '../../'   |    './src/",
      initial : './src'
    };

    const extensionModules = {
      type : 'multiselect',
      name : 'extensionModules',
      message : 'Please select the modules you require for your extension',
      choices : [
        {name : 'popup', message : 'Popup', value : true},
        {name : 'options', message : 'Options', value : true},
        {name : 'contentScripts', message : "Content Scripts", value : true},
        {name : 'webAccessibleScripts', message : 'Web Access Scripts', value : true},
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

    const initialPrompts = [
      languageUsedPrompt, 
      viewLibrary,
      srcDirPathPrompt, 
      extensionModules,
      webpackRequirements
    ];
  
    promptAnswers = await prompter.prompt(initialPrompts);
    // const absoluteSrcDirectoryPath = path.resolve(promptAnswers.srcDir);
    
    Object.assign(promptAnswers, {
      appName : packageJson.name,
      description : packageJson.description,
      appVersion : packageJson.version
      // src : absoluteSrcDirectoryPath
    });
    console.log(`Prompt Answers for chrome extension generator are : `, promptAnswers);
    await executeCommands(promptAnswers);
    await addScriptsAndBrowsersListConfig(promptAnswers);
    return promptAnswers;
  }
};


async function executeCommands(promptAnswers) {
  const assetsPath = path.join(promptAnswers.srcDir, 'assets');
  console.log(`Assets Path is  : `, assetsPath);
  // creating assets directory
  await makeDir(assetsPath);
  // copy assets
  await copyFiles(
    hygenConfig.templates + '/my-gen/ce/assets/*',
    path.normalize(promptAnswers.srcDir + '/assets')
  );

  if (promptAnswers.viewLibrary.react) {
    await addNewPackage('react react-dom'); 
  }
}

async function addScriptsAndBrowsersListConfig (promptAnswers) {
  console.log("Webpack generator : Writing to package.json file!!!");
  const jsonToAppend = {};
  
  const browserslist = {
      "development": [
        "last 2 chrome versions",
        "last 2 firefox versions",
        "last 2 edge versions"
      ],
      "production": [
        ">1%",
        "last 4 versions",
        "Firefox ESR",
        "not ie < 11"
      ]
  };

  jsonToAppend["scripts"] = get(packageJson, "webpack");
  jsonToAppend["browserslist"] = browserslist;

  Object.assign(packageJson, jsonToAppend);
  // writing to package JSON 
  await writePackage(packageJson);
}