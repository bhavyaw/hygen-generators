---
to : "<%= viewLibrary === 'react' && extensionModules.includes('options') ? ( h.src() + '/' + srcDir + '/options/Options' + (sass ? '.scss' : '.css') ) : null %>"
---
/*@import '../../../assets//styles/bootstrap/config';
@import '../../../assets//styles/bootstrap/bootstrap-ext';*/

html {
  min-width: 700px;
  height: 600px;
  max-height: 600px;
  overflow: hidden;
}

body {
  font-family : Poppins;
  overflow: hidden;
  background : url(../../assets/images/papyrus.png);
}
