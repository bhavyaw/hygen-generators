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
    await executeCommands(promptAnswers);

    return promptAnswers;
  }
}

async function executeCommands(promptAnswers) {
  console.log('inside executeCommands() for styling generator');
  if (promptAnswers.sass) {
    await addNewPackage("sass-loader");
    await addNewPackage("node-sass");
  }

  if (promptAnswers.cssModule === 'normal') {
    await addNewPackage("sass-loader");
    await addNewPackage("css-loader");
    await addNewPackage("style-loader");
  }

  if (promptAnswers.cssModule === 'babel' && viewLibrary === 'react') {
    await addNewPackage('babel-plugin-react-css-modules postcss-scss postcss-nested postcss-import-sync2');
  } else if (viewLibrary !== 'react') {
    console.error(`Babel react css modules work only with react...use normal css modules otherwise`);
  }
}
