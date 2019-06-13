---
to : "<%= viewLibrary === 'react' && extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/PopupContainer/PopupContainer.jsx' ) : null %>"
---
import React, { useState } from 'react';
import "./Popup.scss";<% if (cssModule === 'babel') {%>
import "./PopupContainer.module.scss";<%}%><% if(cssModule === 'normal') { %>
import Styles from "./PopupContainer.module.scss";<%}%>

export default function PopupContainer() {
  // Declare a new state variable, which we'll call "count"
  const [count, setCount] = useState(0);

  return (<% if (cssModule === 'babel') {%>
    <div styleName="pop-up"><%}%><% if (cssModule === 'normal') {%>
    <div className={Styles.popUp}><%}%>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}