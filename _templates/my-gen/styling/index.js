const {addNewPackage} = require('../../../commands');

module.exports = {
  prompt : async ({prompter, args}) => {
    let promptAnswers = {};

    const stylingRequirementsPrompt = {
      type : "multiselect",
      name : "styling",
      message : "Cool...how do you want to configure your styling workflow ? ",
      choices : [
        { name : 'sass', message : 'SASS' },
        { cssModules : 'cssModules ( with SASS )', message : 'cssModules'}
      ]
    };

    promptAnswers = await prompter.prompt(stylingRequirementsPrompt);
    console.log("webpack common requirements : ", JSON.stringify(promptAnswers, undefined, 4));
    // run required commoands
    await executeCommands(promptAnswers);

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
}
