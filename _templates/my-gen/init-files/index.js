// my-generator/my-action/index.js
module.exports = {
  prompt: async ({ prompter, args }) => {
      const configFilesOptions = {
        type : "multiselect",
        name : "configFiles",
        message : "Select configuration settings",
        choices : [
          {name : "gitignore", message : "Add git basic file to the project", value : true},
          {name : "prettier", message : "Add a basic prettier file to the project", value : true},
        ]
      }

      const linters = {
        type : "select",
        name : "linter",
        message : "Select code linter",
        choices : [
          {name : "none", message : "none", value : true},
          {name : "eslint", message : "eslint", value : true},
          {name : "tslint", message : "tslint", value : true}
        ]
      };

      const initialPrompts = [
        configFilesOptions,
        linters
      ];

      const answers = await prompter.prompt(initialPrompts);
      console.log("answers are : \n", answers);


      return answers;
  }
}