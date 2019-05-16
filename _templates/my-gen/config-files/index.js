// my-generator/my-action/index.js
module.exports = {
  prompt: async ({ prompter, args }) => {
      const gitignorePrompt = {
        type : 'confirm',
        name : 'gitignore',
        message : "Do you want to add a basic gitignore file"
      };

      const prettierPrompt = {
        type : 'confirm',
        name : 'prettier',
        message : "Do you want to a basic prettier configuration file to the project ?"
      };

      const lintingPrompt = {
        type : "confirm",
        name : "linting",
        message : "Do you want to setup linting - eslint for JavaScript based projects or tslint for Typescript based projects"
      };


      const initialPrompts = [
        gitignorePrompt,
        prettierPrompt,
        lintingPrompt
      ]

      // 1st prompt
      const answers = await prompter.prompt(initialPrompts);
      return answers;
  }
}