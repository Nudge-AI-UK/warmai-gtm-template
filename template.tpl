___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Warm AI - Website Visitor Analytics",
  "categories": ["ANALYTICS", "MARKETING"],
  "brand": {
    "id": "brand_warm_ai",
    "displayName": "Warm AI",
    "thumbnail": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAACXBIWXMAAAsTAAALEwEAmpwYAAABj0lEQVR4nO2WvUoDQRSFv0RFsLCwsLGwEKzsLLSwsLCxsLGxsLCxs7OwsLAQLCwsxMJCsLHwH4KFhYWNhYWFhYWg+AAWdmFZdjY7s5vNBnLgwDDD3HPv3Ll3BqZoij+NAHANvAJfwAPQW5H9S2AX6AdeYxawB9wA38ABsFaR/RNgD/gBjoC1iux3A1dAK3AMrJRgvxu4BNqAY2C5IvtnwAXQBhwBy4Hs3wLnQAdwACwFsp8Bp0AncAAsVmQ/BY6BTuAAWKjIfgwcAV3APjBfkf0QOAa6gX1gLpD9IDgCeoB9YLYi+wFwCPQC+8BMRXZ/+AF6gf1guiL7HnAE9AH7wFQg+y5wBPQD+8BkIPs2cAQMAPvAREX2beAQGAIOgPGK7FvAITAMHABjFdnXgUNgFDgAxiqyPwcOgTHgABgNZH8GHALjwAEwUpF9FTgExoEDYDiQ/QlwCEwAB8BQIPtj4BCYAg6AwUD2B8AhMA0cAP2B7PeBQ2AW2Ad6K7LfAw6BOWAf6A5k/w/1C7EUoqg1TmsaAAAAAElFTkSuQmCC"
  },
  "description": "Track website visitors and their engagement with Warm AI analytics. Captures page views, session duration, and scroll depth to help identify your most engaged visitors.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "trackingId",
    "displayName": "Tracking ID",
    "simpleValueType": true,
    "help": "Enter your Warm AI Tracking ID (found in your Warm AI dashboard under Settings → Tracking Code)",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "SELECT",
    "name": "eventType",
    "displayName": "Event Type",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "page_view",
        "displayValue": "Page View"
      },
      {
        "value": "session_start",
        "displayValue": "Session Start"
      }
    ],
    "simpleValueType": true,
    "defaultValue": "page_view",
    "help": "Select the type of event to track. Use 'Page View' for most triggers."
  },
  {
    "type": "CHECKBOX",
    "name": "trackScrollDepth",
    "checkboxText": "Track Scroll Depth",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "When enabled, tracks how far visitors scroll down the page (0-100%)"
  },
  {
    "type": "CHECKBOX",
    "name": "trackDuration",
    "checkboxText": "Track Page Duration",
    "simpleValueType": true,
    "defaultValue": true,
    "help": "When enabled, tracks time spent on each page in seconds"
  },
  {
    "type": "GROUP",
    "name": "advancedSettings",
    "displayName": "Advanced Settings",
    "groupStyle": "ZIPPY_CLOSED",
    "subParams": [
      {
        "type": "TEXT",
        "name": "customEndpoint",
        "displayName": "Custom Tracking Endpoint (optional)",
        "simpleValueType": true,
        "help": "Override the default tracking endpoint. Leave blank to use the default Warm AI endpoint."
      },
      {
        "type": "TEXT",
        "name": "sessionTimeout",
        "displayName": "Session Timeout (minutes)",
        "simpleValueType": true,
        "defaultValue": "30",
        "help": "Time in minutes before a session expires due to inactivity"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const sendPixel = require('sendPixel');
const encodeUriComponent = require('encodeUriComponent');
const getUrl = require('getUrl');
const getReferrerUrl = require('getReferrerUrl');
const getCookieValues = require('getCookieValues');
const setCookie = require('setCookie');
const generateRandom = require('generateRandom');
const getTimestampMillis = require('getTimestampMillis');
const localStorage = require('localStorage');
const log = require('logToConsole');

// Configuration
const TRACKING_ENDPOINT = data.customEndpoint || 'https://www.getwarmai.com/api/gtm-track';
const SESSION_COOKIE = 'warm_session';
const SESSION_TIMEOUT = (data.sessionTimeout || 30) * 60 * 1000; // Convert to ms

// Generate a UUID-like session token
function generateSessionToken() {
  const timestamp = getTimestampMillis();
  const random1 = generateRandom(100000, 999999);
  const random2 = generateRandom(100000, 999999);
  return 'w' + timestamp + '-' + random1 + '-' + random2;
}

// Get or create session token
function getSessionToken() {
  const existingToken = getCookieValues(SESSION_COOKIE)[0];

  if (existingToken) {
    // Refresh the cookie expiry
    setCookie(SESSION_COOKIE, existingToken, {
      'max-age': SESSION_TIMEOUT / 1000,
      path: '/',
      secure: true,
      samesite: 'Lax'
    });
    return existingToken;
  }

  // Create new session
  const newToken = generateSessionToken();
  setCookie(SESSION_COOKIE, newToken, {
    'max-age': SESSION_TIMEOUT / 1000,
    path: '/',
    secure: true,
    samesite: 'Lax'
  });
  return newToken;
}

// Get scroll depth from localStorage (set by scroll listener)
function getScrollDepth() {
  if (!data.trackScrollDepth) return 0;
  const depth = localStorage.getItem('warm_scroll_depth');
  return depth ? depth : 0;
}

// Get page duration from localStorage (set by timer)
function getPageDuration() {
  if (!data.trackDuration) return 0;
  const startTime = localStorage.getItem('warm_page_start');
  if (!startTime) return 0;
  return Math.round((getTimestampMillis() - startTime) / 1000);
}

// Build tracking URL with all parameters
function buildTrackingUrl() {
  const sessionToken = getSessionToken();
  const currentUrl = getUrl('href');
  const path = getUrl('path');
  const host = getUrl('host');
  const referrer = getReferrerUrl('href') || '';
  const scrollDepth = getScrollDepth();
  const duration = getPageDuration();

  // Build query string
  const params = [
    'tid=' + encodeUriComponent(data.trackingId),
    'et=' + encodeUriComponent(data.eventType),
    'st=' + encodeUriComponent(sessionToken),
    'url=' + encodeUriComponent(currentUrl),
    'path=' + encodeUriComponent(path),
    'host=' + encodeUriComponent(host),
    'ref=' + encodeUriComponent(referrer),
    'ts=' + getTimestampMillis()
  ];

  if (data.trackScrollDepth) {
    params.push('sd=' + scrollDepth);
  }

  if (data.trackDuration) {
    params.push('dur=' + duration);
  }

  return TRACKING_ENDPOINT + '?' + params.join('&');
}

// Initialize page tracking (set start time)
if (data.eventType === 'session_start' || data.eventType === 'page_view') {
  localStorage.setItem('warm_page_start', getTimestampMillis());
  localStorage.setItem('warm_scroll_depth', 0);
}

// Send the tracking pixel
const trackingUrl = buildTrackingUrl();

log('Warm AI: Sending tracking event', {
  type: data.eventType,
  url: trackingUrl
});

sendPixel(trackingUrl, data.gtmOnSuccess, data.gtmOnFailure);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "send_pixel",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://www.getwarmai.com/*"
              },
              {
                "type": 1,
                "string": "https://getwarmai.com/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        },
        {
          "key": "cookieNames",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "warm_session"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "set_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedCookies",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "name"
                  },
                  {
                    "type": 1,
                    "string": "domain"
                  },
                  {
                    "type": 1,
                    "string": "path"
                  },
                  {
                    "type": 1,
                    "string": "secure"
                  },
                  {
                    "type": 1,
                    "string": "session"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "warm_session"
                  },
                  {
                    "type": 1,
                    "string": "*"
                  },
                  {
                    "type": 1,
                    "string": "/"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  },
                  {
                    "type": 1,
                    "string": "any"
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_local_storage",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "warm_page_start"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "warm_scroll_depth"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_url",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "get_referrer",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urlParts",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "queriesAllowed",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Basic page view tracking
  code: |-
    const mockData = {
      trackingId: 'test-tracking-id',
      eventType: 'page_view',
      trackScrollDepth: true,
      trackDuration: true
    };

    runCode(mockData);

    assertApi('sendPixel').wasCalled();
    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Warm AI Website Visitor Analytics Template

This template tracks website visitors for B2B lead identification.
It captures page views, session data, scroll depth, and time on page.

For setup instructions, visit: https://docs.getwarmai.com/tracking/gtm

Changelog:
- v1.0.0: Initial release with page view tracking
