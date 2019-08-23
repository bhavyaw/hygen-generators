---
to : "<%= viewLibrary === 'react' && extensionModules.includes('options') ? ( h.src() + '/' + srcDir + '/options/OptionsContainer/OptionsContainer.jsx' ) : null %>"
---
import React, { useState } from 'react';<% if (cssModule === 'babel') {%>
import "<%= './OptionsContainer.module' + (sass ? '.scss' : '.css')%>";<%}%><% if(cssModule === 'normal') { %>
import Styles from "<%= './OptionsContainer.module' + (sass ? '.scss' : '.css') %>";<%}%>

export default function OptionsContainer() {
  // Declare a new state variable, which we'll call "count"
  const [count, setCount] = useState(0);

  return (<% if (cssModule === 'babel') {%>
    <div styleName="options-wrapper"><%}%><% if (cssModule === 'normal') {%>
    <div className={Styles.optionsWrapper}><%}%><% if (cssModule === 'none') {%>
    <div><%}%>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}