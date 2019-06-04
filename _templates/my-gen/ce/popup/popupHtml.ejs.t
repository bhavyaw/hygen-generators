---
to : "<%= extensionModules.includes('popup') ? ( h.src() + '/' + srcDir + '/popup/popup.html' ) : null %>"
---
<!doctype html>
<html>
    <head>
        <title><%= appName %></title>
    </head>

    <body class="overflow-hidden h-100">
        <div id="pop-up-container" class="pop-up-container"></div>
    </body>
</html>