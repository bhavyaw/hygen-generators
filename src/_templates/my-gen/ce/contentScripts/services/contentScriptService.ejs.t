---
to : "<%= extensionModules.includes('contentScripts') ?  ( h.src() + srcDir + '/contentScripts/services/contentScriptService.js' ) : null %>"
---


export function testServiceFunc() {
  console.log(`This is a test service function!!`);
}