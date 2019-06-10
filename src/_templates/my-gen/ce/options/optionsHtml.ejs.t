---
to : "<%= extensionModules.includes('options') ? ( h.src() + '/' + srcDir + '/options/options.html' ) : null %>"
---
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1.0">
  <title><%= appName %></title>
</head>

<body>
  <div id="options-container"></div>
  <b>Sample options page</b>
</body>
</html>