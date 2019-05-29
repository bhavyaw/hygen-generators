const {addNewPackage} = require('../../../commands');
const path = require("path");

module.exports = {
  prompt : async ({prompter, args}) => {
    let promptAnswers =  {};

    const languageUsedPrompt = {
      type : 'select',
      name : 'language',
      message : 'Please select the language for the project...',
      choices : [
        {name : 'JS', message : 'JavaScript', value : true},
        {name : 'TS', message : 'Typescript', value : true}
      ]
    };

    const srcDirPathPrompt = {
      type : 'input',
      name: 'srcDir',
      message: '\nPlease Enter your source directory path \n',
      hint : "For eg : '../'   |   '../../'   |    './src/",
      initial : './'
    };

    const commonRequirementsPrompts = {
        type : 'multiselect',
        name: 'webpackBasic',
        message: '\nPlease select your webpack requirements ( using spacebar ): \n',
        choices: [
          { name:  'es6', message: 'ES6+ Compilation ( using babel loader )', value : true },
          { name : 'images', message : 'Images Loader', value : true},
          { name : 'fonts', message : 'Fonts Loader', value : true},
          { name : 'css', message : 'CSS', value : true},
        ]
    };

    promptAnswers = await prompter.prompt(languageUsedPrompt);
    Object.assign(promptAnswers, await prompter.prompt(srcDirPathPrompt));
    Object.assign(promptAnswers, await prompter.prompt(commonRequirementsPrompts));

    // const absoluteSrcDirectoryPath = path.resolve(promptAnswers.srcDir);
    // console.log("absolute source directory path : ", absoluteSrcDirectoryPath);
    console.log('webpack common requirements : ', JSON.stringify(promptAnswers, undefined, 4));

    // Object.assign(promptAnswers, {
    //   srcDir : absoluteSrcDirectoryPath
    // });
    // // run required commoands
    await executeCommands(promptAnswers);
    return promptAnswers;
  }
}

async function executeCommands(promptAnswers) {
  if (promptAnswers.webpackBasic.includes('CSS')) {
    await addNewPackage('css-loader');
    await addNewPackage('style-loader');
  }

  if (promptAnswers.webpackBasic.includes('images')) {
    await addNewPackage('url-loader');
    await addNewPackage('file-loader');
  }

  if (promptAnswers.webpackBasic.includes('fonts')) {
    await addNewPackage('url-loader');
  }
}

/**
 *           { name: 'jsx', message : 'JSX Compilation ( For React - using babel loader )', value: true },
 */