---
to: "<%= h.src() %>/<%= srcDir %>/background/main.js"
---
import { APP_CONSTANTS } from 'appConstants';
import { APP_MESSAGES } from 'appMessages';

initializeBackgroundScript();

async function initializeBackgroundScript() {
  console.log('Initializing Background script...');
  // TODO : enable this in production
  // browser start event
  // chrome.runtime.onStartup.addListener(async () => {
  // });

  handleBrowserStartEvent();
}

function handleBrowserStartEvent() {
  // showDesktopNotification(`Browser has started!!!`);
  intiateRefreshCycle();
  listenToTabEvents();
  // extension message handler
}

function listenToTabEvents() {
  const tabTestRegex1 = /myaccount\.google\.com\/(u\/\d\/|intro\/)?activitycontrols$/i;
  const tabTestRegex2 = /myactivity.google.com\/item/i;

  chrome.tabs.onUpdated.addListener((tabId, info, tab) => {
    if (info.status === 'complete') {
      console.log(`Tab updated  : `, tab);
      const url = new URL(tab.url);
      const completeUrl = url.host + url.pathname;

      if (tabTestRegex1.test(completeUrl)) {
        console.log('1st test tab opened');
      }

      if (
        tabTestRegex2.test(completeUrl)
      ) {
        console.log(`2nd test tab opened`, tab);
      }
    }
  });

  //chrome.tabs.onRemoved.addListener(function(closedTabId) {
  //  
  //});
}
