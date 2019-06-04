const {addNewPackage, packageJson, copyFiles, hygenConfig} = require('../../../utils');
const makeDir = require('make-dir');
const path = require('path');

module.exports = {
  prompt : async({prompter, args}) => {
    let promptAnswers =  {};

    // common to all generators
    const srcDirPathPrompt = {
      type : 'input',
      name: 'srcDir',
      message: '\nPlease Enter your source directory path \n',
      hint : "For eg : '../'   |   '../../'   |    './src/",
      initial : './src'
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
  
    promptAnswers = await prompter.prompt([srcDirPathPrompt, viewLibrary, extensionModules]);
    // const absoluteSrcDirectoryPath = path.resolve(promptAnswers.srcDir);
    
    Object.assign(promptAnswers, {
      appName : packageJson.name,
      description : packageJson.description,
      appVersion : packageJson.version
      // src : absoluteSrcDirectoryPath
    });
    console.log(`Prompt Answers for chrome extension generator are : `, promptAnswers);
    await executeCommands(promptAnswers);
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
