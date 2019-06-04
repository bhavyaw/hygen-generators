---
to : "<%= extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/popup.js' ) : null %>"
---
import { APP_CONSTANTS } from 'appConstants';<% if (viewLibrary === 'react') {%>
import * as React from 'react';
import * as ReactDOM from 'react-dom';
import PopupContainer from './components/PopupContainer/PopupContainer';<%}%>

console.log("inside popup script");
startPopUpScript();

function startPopUpScript() {
  initialize();
  // inter exchange message handler
}

function initialize() {<% if (viewLibrary === 'react') {%>
  renderPopupComponent();<%}%>
}
<% if (viewLibrary === 'react') {%>
function renderPopupComponent() {
  // Get the DOM Element that will host our React application
  const rootEl = document.getElementById('pop-up-container');
  // Render the React application to the DOM
  ReactDOM.render(<PopupContainer />, rootEl);
}
<%}%>