---
to : "<%= viewLibrary === 'react' && extensionModules.includes('options') ? ( h.src() + '/' + srcDir + '/options/OptionsContainer/Options' + (sass ? '.scss' : '.css') ) : null %>"
---
/*@import '../../../assets//styles/bootstrap/config';
@import '../../../assets//styles/bootstrap/bootstrap-ext';*/

html {
  min-width: 400px;
  height: 600px;
  max-height: 600px;
  overflow: hidden;
}

body {
  overflow: hidden;
}

.cursor-pointer {
  cursor: pointer;
}

.cursor-na {
  cursor: not-allowed;
}

input[disabled],
select[disabled],
button[disabled] {
  @extend .cursor-na;
}
