const {addNewPackage} = require('../../../utils');

module.exports = {
  prompt : async ({prompter, args}) => {
    let promptAnswers = {};

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
        { name : 'normal', message : 'Normal CSS Modules'},
        { name : 'babel', message : 'Babel Plugin react css modules'}
      ]
    };

    promptAnswers = await prompter.prompt([stylingRequirementsPrompt, cssModulesType]);
    console.log("webpack common requirements : ", JSON.stringify(promptAnswers, undefined, 4));
    // run required commoands
    // await executeCommands(promptAnswers);

    return promptAnswers;
  }
}

async function executeCommands(promptAnswers) {
  if (promptAnswers.sass) {
    await addNewPackage("sass-loader");
    await addNewPackage("node-sass");
  }

  if (promptAnswers.cssModules) {
    await addNewPackage("sass-loader");
    await addNewPackage("css-loader");
    await addNewPackage("style-loader");
  }

  if (promptAnswers.cssModules === 'babel') {
    await addNewPackage('babel-plugin-react-css-modules babel-plugin-module-resolver postcss-scss postcss-nested postcss-import-sync2');
  }
}
