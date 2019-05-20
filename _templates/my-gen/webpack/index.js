const {addNewPackage} = require('../../../commands');

console.log("inside index.js  : ". addNewPackage);

// my-generator/my-action/index.js
module.exports = {
  prompt : async ({prompter, args}) => {
    let promptAnswers =  {};
    const commonRequirementsPrompts = {
        type : "multiselect",
        name: 'webpackCommon',
        message: '\nPlease select your webpack requirements ( using spacebar ): \n',
        choices: [
          { name: 'es6', message: 'ES6+ Compilation ( using babel loader )', value : true },
          { name: 'jsx', message : 'JSX Compilation ( For React - using babel loader )', value: true },
        ]
    };

    // const srcDirPathPrompt = {
    //   type : "input",
    //   name: 'srcDir',
    //   message: '\nPlease Enter your source directory path \n',
    //   hint : "For eg : '../'   |   '../../'   |    './src/",
    //   initial : "./"
    // }

    promptAnswers = await prompter.prompt(commonRequirementsPrompts);
    // Object.assign(promptAnswers, await prompter.prompt(srcDirPathPrompt));

    console.log("webpack common requirements : ", promptAnswers);

    // run required commoands
    await executeCommands(promptAnswers);
    return promptAnswers;
  }
}

async function executeCommands(promptAnswers) {
  await addNewPackage("webpack");
  await addNewPackage("webpack-cli");
  await addNewPackage("webpack-glob-entries");
  await addNewPackage("lodash");
}