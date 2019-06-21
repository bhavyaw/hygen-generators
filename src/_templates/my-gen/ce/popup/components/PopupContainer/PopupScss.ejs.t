---
to : "<%= viewLibrary === 'react' && extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/PopupContainer/Popup' + (sass ? '.scss' : '.css') ) : null %>"
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
  background : url (../../assets/images/papyrus.png);
}

.cursor-pointer {
  cursor: pointer;
}

.cursor-na {
  cursor: not-allowed;
}
