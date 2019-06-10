const shell = require("shelljs");
const get = require("lodash/get");
const isEmpty = require("lodash/isEmpty");
const readPkg = require('read-pkg');
const hygenConfig = require(process.cwd() + '/.hygen.js');

// TODO : use better option than process.cwd()
// const packageJsonPath = path.join(process.cwd(), "/package.json");
// const packageJson = awaitrequire(packageJsonPath);
const packageJson = readPkg.sync();

if (isEmpty(packageJson)) {
  throw new Error("Package json is either empty or missing")
} 

if (isEmpty(hygenConfig)) {
  console.error(`Hygen config not found!!!`);
}

module.exports = {
  addNewPackage,
  shellExecAsync,
  packageJson,
  hygenConfig,
  copyFiles
};

/**
 * @param {*} packageName 
 * @param {*} dependencyType {string} - "dev" | "normal"
 * @param {*} packageManager 
 */
async function addNewPackage(packageName = "", dependencyType = "dev", packageManager = "yarn") {
  packageName = packageName.split(/\s+/).filter(i => i.length);
  let packages = [];
  if (isEmpty(packageName)) {
    throw new Error("Package name cannot be empty!!");
  }

  if (packageName.length > 1) {
    packages = [...packageName];
  } else {
    packages = [packageName];
  }

  dependencyType = dependencyType === "dev" ? "devDependencies" : "dependencies";
  for (let i = 0; i < packages.length; i++) {
    const package = packages[i];
    const isPackageInstalled = get(packageJson, [ dependencyType, package]);

    if (isPackageInstalled) {
      console.log(`${package} is already installed.....skipping installation`);
    } else {
      await shellExecAsync(`yarn add --silent ${dependencyType ? "-D" : ""} ${package} `, {}, true);
    }
  }
}

async function copyFiles(copyFrom, copyTo) {
  const copyCommand = `cp ${copyFrom} ${copyTo}`;
  console.log(`Inside copyFiles : `, copyCommand);
  await shellExecAsync(copyCommand, {}, true);
}

function shellExecAsync(command, opts = {}, logError = false) {
  return new Promise((resolve, reject) => {
    shell.exec(command, (code, stdout, stderr) => {
      if (code === 0) {
        resolve(stdout)
      } else {
        if (logError) {
          console.error("\n\n",stderr, "\n");
        }
      }
    });
  });
}