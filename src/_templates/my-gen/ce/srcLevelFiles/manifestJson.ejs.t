---
to : "<%= h.src()%>/<%= srcDir %>/manifest.json"
---
{
    "manifest_version": 2,
    "name": "<%= appName %>",
    "description": "<%= description %>",
    "version": "<%= appVersion %>",<% if (extensionModules.includes('popup')) { %>
    "browser_action": {
        "default_icon": "./assets/icon16.png",
        "default_popup": "popup.html"
    },<%}%>
    "icons": {
        "16": "./assets/icon16.png",
        "48": "./assets/icon48.png",
        "128": "./assets/icon128.png"
    },
    "content_security_policy": "script-src 'self'; object-src 'self'",<% if (extensionModules.includes('options')) { %>
    <% if (embeddedOptionsPage) {%>
    "options_ui": {
        "page": "options.html",
        "open_in_tab": false
    },
    <%}%><% if (!embeddedOptionsPage) {%>
    "options_page": "options.html",
    <%}%><%}%><% if (extensionModules.includes('contentScripts')) {%>
    "content_scripts": [
        {
            "matches": [
                "*://*/*"
            ],
            "js": [
                "./js/contentScript1.js"
            ]
        }
    ],<%}%>
    "background": {
        "page": "background.html",
        "persistent": <%=extensionModules.includes('persistentBackground') ? true : false %>
    },<% if (extensionModules.includes('webAccessScript')) { %>
    "web_accessible_resources": [
        "js/webAccessScript.js"
    ], <%}%>
    "permissions": [
        "tabs",
        "storage",
        "unlimitedStorage",
        "<all_urls>",
        "notifications"
    ]
}