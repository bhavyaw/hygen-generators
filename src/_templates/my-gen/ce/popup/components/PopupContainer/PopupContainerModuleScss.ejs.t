---
to : "<%= !viewLibrary.includes('none') && extensionModules.includes('popup') && (cssModule !== 'none') ? ( h.src() + '/' + srcDir + '/popup/PopupContainer/PopupContainer.module' + (sass ? '.scss' : '.css')) : null %>"
---
.pop-up {
  background: url(../../assets/icon16.png);
}
