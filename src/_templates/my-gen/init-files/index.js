const {addNewPackage, packageJson} = require('../../../utils');
const packageScripts = require('../../../utils/packageScripts');
const get = require("lodash/get");
const writePackage = require('write-pkg');

// my-generator/my-action/index.js
module.exports = {
  prompt: async ({ prompter, args }) => {
      const configFilesOptions = {
        type : "multiselect",
        name : "configFiles",
        message : "Select configuration settings",
        choices : [
          {name : "gitignore", message : "Add a basic gitignore  file to the project", value : true},
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

      const lintReactPrompt = {
        type : "confirm",
        name : "lintReact",
        message : "Do you want add linting support React as well"
      };

      const initialPrompts = [
        configFilesOptions,
        linters,
        lintReactPrompt
      ];

      const answers = await prompter.prompt(initialPrompts);
      console.log("answers are : \n", answers);

      await addConfigToPackageJson(answers);
      await addNodePackages(answers);
      return answers;
  }
}


async function addConfigToPackageJson (promptAnswers) {
  console.log("Webpack generator : Writing to package.json file!!!");
  const jsonToAppend = {};

  if (promptAnswers.linter.includes("eslint")) {
    const existingScripts = get(packageJson, "scripts") || {};
    const eslintScripts = get(packageScripts, "eslint");
    const newScripts = Object.assign({}, existingScripts, eslintScripts);
    jsonToAppend["scripts"] = newScripts;
    Object.assign(packageJson, jsonToAppend);
    // console.log("inside addConfigToPackageJson() : ", jsonToAppend);
    // writing to package JSON 
    await writePackage(packageJson);
  }
}

async function addNodePackages(promptAnswers) {
  await addNewPackage("onchange", "dev");
  if (promptAnswers.linter.includes('eslint')) {
    await addNewPackage(`
      eslint
      babel-eslint
      onchange
      eslint-config-airbnb
      eslint-plugin-html  
      eslint-plugin-import
    `,"dev");
  }

  if (promptAnswers.configFiles.includes('prettier')) {
    await addNewPackage(`prettier`, "dev");

    if (promptAnswers.linter.includes("eslint")) {
      await addNewPackage("eslint-plugin-prettier eslint-config-prettier", "dev");
    }
  }

  if (promptAnswers.lintReact) {
    await addNewPackage(`eslint-plugin-react eslint-plugin-react-hooks eslint-plugin-jsx-a11y`, "dev");
  }
}
