const {addNewPackage} = require('../../../commands');

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

    const commonRequirementsPrompts = {
        type : 'multiselect',
        name: 'webpackBasic',
        message: '\nPlease select your webpack requirements ( using spacebar ): \n',
        choices: [
          { name: 'es6', message: 'ES6+ Compilation ( using babel loader )', value : true, enabled : true },
          { name : 'images', message : 'Images Loader', value : true},
          { name : 'css', message : 'CSS', enabled : true},
          { name : 'inlineImages', message : 'Inline Images <8kb ( Optimization )'},
        ]
    };

    const srcDirPathPrompt = {
      type : 'input',
      name: 'srcDir',
      message: '\nPlease Enter your source directory path \n',
      hint : "For eg : '../'   |   '../../'   |    './src/",
      initial : './'
    };

    promptAnswers = await prompter.prompt(languageUsedPrompt);
    Object.assign(promptAnswers, await prompter.prompt(commonRequirementsPrompts));
    Object.assign(promptAnswers, await prompter.prompt(srcDirPathPrompt));

    console.log('webpack common requirements : ', JSON.stringify(promptAnswers, undefined, 4));

    // run required commoands
    await executeCommands(promptAnswers);
    return promptAnswers;
  }
}

async function executeCommands(promptAnswers) {
  if (promptAnswers.webpackBasic.includes('CSS')) {
    await addNewPackage('css-loader');
    await addNewPackage('style-loader');
  }

  if (promptAnswers.webpackBasic.includes('inline-images')) {
    await addNewPackage('url-loader');
  }
}

/**
 *           { name: 'jsx', message : 'JSX Compilation ( For React - using babel loader )', value: true },
 */