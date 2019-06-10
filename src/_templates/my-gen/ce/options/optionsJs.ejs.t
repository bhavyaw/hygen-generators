---
to : "<%= extensionModules.includes('options') ? ( h.src() + '/' + srcDir + '/options/options.js' ) : null %>"
---
import { APP_CONSTANTS } from '../appConstants';<% if (viewLibrary === 'react') {%>
import * as React from 'react';
import * as ReactDOM from 'react-dom';
import OptionsContainer from './OptionsContainer/OptionsContainer';<%}%>

console.log('inside options script!');
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
  const rootEl = document.getElementById('options-container');
  // Render the React application to the DOM
  ReactDOM.render(<OptionsContainer />, rootEl);
}
<%}%>