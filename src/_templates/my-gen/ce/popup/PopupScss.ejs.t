---
to : "<%= viewLibrary === 'react' && extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/Popup' + (sass ? '.scss' : '.css') ) : null %>"
---
/*@import '../../../assets//styles/bootstrap/config';
@import '../../../assets//styles/bootstrap/bootstrap-ext';*/

/* poppins-regular - latin */
@font-face {
  font-family: 'Poppins';
  font-style: normal;
  font-weight: 400;
  src: url('../../assets/fonts/poppins-v6-latin/poppins-v6-latin-regular.woff2') format('woff2'), 
       url('../../assets/fonts/poppins-v6-latin/poppins-v6-latin-regular.woff') format('woff'),
       url('../../assets/fonts/poppins-v6-latin/poppins-v6-latin-regular.ttf') format('truetype');
}

html {
  min-width: 400px;
  height: 600px;
  max-height: 600px;
  overflow: hidden;
}

body {
  font-family : Poppins;
  font-size : 20px;
  overflow: hidden;
  background : url(../../assets/images/papyrus.png);
}