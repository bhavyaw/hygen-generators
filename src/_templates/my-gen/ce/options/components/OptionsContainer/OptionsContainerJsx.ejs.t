---
to : "<%= viewLibrary === 'react' && extensionModules.includes('options') ? ( h.src() + '/' + srcDir + '/options/OptionsContainer/OptionsContainer.jsx' ) : null %>"
---
import React, { useState } from 'react';

export default function OptionsContainer() {
  // Declare a new state variable, which we'll call "count"
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}