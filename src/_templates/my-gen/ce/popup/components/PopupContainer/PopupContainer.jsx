---
to : "<%= viewLibrary === 'react' && extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/PopupContainer/PopupContainer.jsx' ) : null %>"
---
import React, { useState } from 'react';
import "<%= './Popup' + (sass ? '.scss' : '.css')%>";<% if (cssModule === 'babel') {%>
import "<%= './PopupContainer.module' + (sass ? '.scss' : '.css')%>";<%}%><% if(cssModule === 'normal') { %>
import Styles from "<%= './PopupContainer.module' + (sass ? '.scss' : '.css') %>";<%}%>

export default function PopupContainer() {
  // Declare a new state variable, which we'll call "count"
  const [count, setCount] = useState(0);

  return (<% if (cssModule === 'babel') {%>
    <div styleName="pop-up"><%}%><% if (cssModule === 'normal') {%>
    <div className={Styles.popUp}><%}%><% if (cssModule === 'none') {%>
    <div><%}%>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}