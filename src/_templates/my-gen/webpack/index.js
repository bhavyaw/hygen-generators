const {addNewPackage, packageJson} = require('../../../utils');
const writePackage = require('write-pkg');

module.exports = {
  prompt : async ({prompter, args}) => {
    let promptAnswers =  {};

    const projectTypePrompt = {
      type : 'multiselect',
      name : 'projectType',
      message : 'Please select the Project Type',
      choices : [
        {name : 'react', message : 'React', value : true},
        {name : 'chromeExtension', message : 'Chrome Extension', value : true}
      ]
    };

    // common to all generators
    const languageUsedPrompt = {
      type : 'select',
      name : 'language',
      message : 'Please select the Project Type',
      choices : [
        {name : 'JS', message : 'JavaScript', value : true},
        {name : 'TS', message : 'Typescript', value : true}
      ]
    };

    // common to all generators
    const srcDirPathPrompt = {
      type : 'input',
      name: 'srcDir',
      message: '\nPlease Enter your source directory path \n',
      hint : "For eg : '../'   |   '../../'   |    './src/",
      initial : './src'
    };

    const commonRequirementsPrompts = {
        type : 'multiselect',
        name: 'webpackBasic',
        message: '\nPlease select your webpack requirements ( using spacebar ): \n',
        choices: [
          { name : 'images', message : 'Images Loader', value : true},
          { name : 'fonts', message : 'Fonts Loader', value : true},
          { name : 'css', message : 'CSS', value : true},
        ]
    };

    const initialPrompts = [
      projectTypePrompt,
      languageUsedPrompt,
      srcDirPathPrompt,
      commonRequirementsPrompts
    ];

    promptAnswers = await prompter.prompt(initialPrompts);

    // const absoluteSrcDirectoryPath = path.resolve(promptAnswers.srcDir);
    // console.log("absolute source directory path : ", absoluteSrcDirectoryPath);
    console.log('webpack common requirements : ', promptAnswers, JSON.stringify(promptAnswers, undefined, 4));

    // Object.assign(promptAnswers, {
    //   srcDir : absoluteSrcDirectoryPath
    // });
    // // run required commoands
    // await executeCommands(promptAnswers);
    await addBrowserlistToPackageJson(promptAnswers);
    return promptAnswers;
  }
}

async function executeCommands(promptAnswers) {
  await addNewPackage('webpack webpack-cli webpack-dev-server webpack-merge write-pkg cross-env');

  if (promptAnswers.webpackBasic.includes('CSS')) {
    await addNewPackage('css-loader');
    await addNewPackage('style-loader');
    await addNewPackage('mini-css-extract-plugin');
  }

  if (promptAnswers.webpackBasic.includes('images')) {
    await addNewPackage('url-loader');
    await addNewPackage('file-loader');
  }

  if (promptAnswers.webpackBasic.includes('fonts')) {
    await addNewPackage('url-loader');
  }

  // babel loaders
  if (language === 'JS') {
    await addNewPackage('@babel/core @babel/preset-env babel-loader');
  }

  if (language === 'TS') {
    await addEventListener('@babel/preset-typescript @babel/proposal-class-properties @babel/proposal-object-rest-spread');
  }

  if (projectType === 'react') {
    await addNewPackage('@babel/preset-reac babel-plugin-transform-react-remove-prop-types');
    await addNewPackage('prop-types react react-dom', 'dev');
  }
  // webpack plugins
  await addNewPackage('webpack-copy-plugin clean-webpack-plugin webpack-bundle-analyzer html-webpack-plugin');
}

async function addBrowserlistToPackageJson (promptAnswers) {
  console.log("Webpack generator : Writing to package.json file!!!");
  const jsonToAppend = {};
  jsonToAppend["scripts"] = {
    "build": "cross-env NODE_ENV=production webpack --config ./webpack/webpack.prod.js --mode production --progress", 
  };
  const browserslist = {
      "development": [
        "last 2 chrome versions",
        "last 2 firefox versions",
        "last 2 edge versions"
      ],
      "production": [
        ">1%",
        "last 4 versions",
        "Firefox ESR",
        "not ie < 11"
      ]
  };

  if (promptAnswers.projectType === 'chrome-extension') {
    jsonToAppend["scripts"]["dev"] = "cross-env NODE_ENV=development webpack -w --./webpack/config webpack.dev.js --mode development --progress";
  } else {
    jsonToAppend["browserslist"] = browserslist;
    jsonToAppend["scripts"]["start"] = "cross-env NODE_ENV=development webpack-dev-server --./webpack/config webpack.dev.js --mode development --progress";
  };

  Object.assign(packageJson, jsonToAppend);
  // writing to package JSON 
  await writePackage(packageJson);
}