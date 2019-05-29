---
to : 
---
{
    "presets": [
        [
            "env",
            {
                "targets": {
                    "browsers": [
                        "last 2 versions",
                        "safari >= 7"
                    ]
                }
            }
        ],
        "react",
        "stage-2"
    ],
    "plugins": [
        ["transform-runtime", {
          "polyfill": false,
          "regenerator": true
        }]
      ],
    "env": {
        "production": {
            "plugins": [
                "transform-react-remove-prop-types",
                "transform-react-constant-elements"
            ]
        },
        "test":{
            "plugins":[
                "babel-plugin-dynamic-import-node",
                "transform-react-remove-prop-types"
            ]
        }
    }
}
