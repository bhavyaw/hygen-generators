---
to : "<%= viewLibrary === 'react' && extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/PopupContainer/PopupContainer.module.scss') : null %>"
---
.pop-up {
  background: green;
}
