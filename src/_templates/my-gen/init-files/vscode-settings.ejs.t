---
to: "<%= configFiles.includes('vscodeSettings') ? h.src() + '.vscode/settings.json' : null %>"
---
{
  "eslint.options": {
    "configFile" : "./.eslintrc.js"
  }
}