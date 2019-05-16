// my-generator/my-action/index.js
const shell = require("shelljs");
const packageJson = require(process.cwd() + "/package.json");
const get = require("lodash/get");
const isEmpty = require("lodash/isEmpty");

module.exports = {
  prompt: async ({ prompter, args }) => {
console.log(__dirname, typeof h, process.cwd());

      const useBootstrap = {
        type : 'confirm',
        name : 'useBootstrap',
        message : "Do you want use bootstrap in the project"
      };

      // 1st prompt
      const answers = await prompter.prompt(useBootstrap);

      console.log("Ansers are : ", answers);

      if (answers.useBootstrap) {
        const boostrapBestPractices = {
          type : "confirm",
          name : "bootstrapScss",
          message : "Do you want configure bootstrap scss setup...Bootstrap best practices with scss"
        };

        const answers2 = await prompter.prompt(boostrapBestPractices);
        Object.assign(answers, answers2);
  
        // commands
        const isBootstrapInstalled = get(packageJson, "dependencies.bootstrap");
        if (answers.useBootstrap && !isEmpty(packageJson) && !isBootstrapInstalled) {
          // install bootstrap
          console.log("installing bootstrap...")
          shell.exec('yarn add bootstrap', function(code, stdout, stderr) {
            process.exit();
          });
          // shell.exec('yarn add bootstrap', {async:true});
        } else {
          console.log("skipping boostrap installation")
        }
      }

      return answers;
  }
}