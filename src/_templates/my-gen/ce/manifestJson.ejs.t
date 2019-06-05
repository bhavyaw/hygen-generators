---
to : "<%= h.src()%>/<%= srcDir %>/manifest.json"
---
{
    "manifest_version": 2,
    "name": "<%= appName %>",
    "description": "<%= description %>",
    "version": "<%= appVersion %>",
    "browser_action": {
        "default_icon": "./assets/icon16.png",
        "default_popup": "popup.html"
    },
    "icons": {
        "16": "./assets/icon16.png",
        "48": "./assets/icon48.png",
        "128": "./assets/icon128.png"
    },
    "content_security_policy": "script-src 'self'; object-src 'self'",<% if (extensionModules.includes('options')) { %>
    "options_page": "options.html",<%}%><% if (extensionModules.includes('contentScripts')) {%>
    "content_scripts": [
        {
            "matches": [
               
            ],
            "js": [
                "./js/contentScript1.js"
            ]
        }
    ],<%}%>
    "background": {
        "scripts": [
            "js/vendor.js",
            "js/background.js"
        ],
        "persistent": <%=extensionModules.includes('persistentBackground') ? true : false %>
    },<% if (extensionModules.includes('webAccessibleScripts')) { %>
    "web_accessible_resources": [
        "js/variableAccessScript.js"
    ], <%}%>
    "permissions": [
        "tabs",
        "storage",
        "unlimitedStorage",
        "<all_urls>",
        "notifications"
    ]
}