---
to: "<%= h.src() + '/' + srcDir + '/appConstants.js' %>"
---
export const APP_CONSTANTS = {
    DAY_IN_MS: 86400000
};

export const MESSAGING_CONSTANTS = {
  GET_CONTINUATION_DATA: 'GET_CONTINUATION_DATA',
  CONTINUATION_DATA: 'CONTINUATION_DATA'
};

Object.freeze(APP_CONSTANTS);
Object.freeze(MESSAGING_CONSTANTS);

