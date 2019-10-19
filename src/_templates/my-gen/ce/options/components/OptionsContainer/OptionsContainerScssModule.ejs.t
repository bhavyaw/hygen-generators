---
to : "<%= !viewLibrary.includes('none') && extensionModules.includes('options') && (cssModule !== 'none') ? ( h.src() + '/' + srcDir + '/options/OptionsContainer/OptionsContainer.module' + (sass ? '.scss' : '.css')) : null %>"
---
.options-wrapper {
  font-size: 0.9rem;
}
