const {addNewPackage} = require('../../../commands');

// my-generator/my-action/index.js
module.exports = {
  prompt: async ({ prompter, args }) => {
      const envFileTypes = {
        type : "multiselect",
        name : "envFileTypes",
        message : "Select Config Files ?",
        choices : [
          { name: 'local', message: 'Local', value : true },
          { name : 'development', message : 'Development', value : true},
          { name : 'production', message : 'Prod', enabled : true},
        ]
      };
     
      const initialPrompts = [
        envFileTypes
      ];

      const answers = await prompter.prompt(initialPrompts);

      if (answers.length) {

      }
      console.log("answers are : \n", answers);
      await executeCommands(answers);
      return answers;
  }
}


async function executeCommands(answers) {
  if (answers.envFileTypes.length) {
    await addNewPackage("dotenv");
  }
}
