const shell = require("shelljs");
const get = require("lodash/get");
const isEmpty = require("lodash/isEmpty");
const readPkg = require('read-pkg');


// TODO : use better option than process.cwd()
// const packageJsonPath = path.join(process.cwd(), "/package.json");
// const packageJson = awaitrequire(packageJsonPath);

const packageJson = readPkg.sync();

if (isEmpty(packageJson)) {
  throw new Error("Package json is either empty or missing")
} 

module.exports = {
  addNewPackage,
  shellExecAsync
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

    console.log("inside addNewPackage : ", isPackageInstalled, package);
  
    if (isPackageInstalled) {
      console.log(`${packageName} is already installed.....skipping installation`);
    } else {
      await shellExecAsync(`yarn add ${dependencyType ? "-D" : ""} ${package} `, {}, true);
    }
  }
}


function shellExecAsync(command, opts = {}, logError = false) {
  return new Promise((resolve, reject) => {
    shell.exec(command, (code, stdout, stderr) => {
      if (code === 0) {
        resolve(stdout)
      } else {
        if (logError) {
          console.error(stderr);
        }
      }
    });
  });
}