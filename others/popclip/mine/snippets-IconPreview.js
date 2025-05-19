// #popclip 图标预览
// name: Icon Preview
// identifier: logan.IconPreview
// entitlements: [dynamic]
// language: javascript
// module: true

exports.actions = (input, options, context) => {
    return [
        {
            title: `<${input.text.slice(0, 10)}>`,
            icon: input.text,
            code: (input, options, context) => {
                popclip.showText("Hi from Action");
            },
        },
    ];
};
