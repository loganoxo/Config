// #popclip
// name: Append
// identifier: logan.pasteboard.append
// description: 将选中的文字附加到剪切板后面
// icon: square filled scale=128 move-y=7 +
// requirements: [text]

module.exports = {
    action: (input, options) => {
        let text = pasteboard.text.trim() + options.separator + input.text;
        popclip.copyText(text);
    },
    options: [
        {
            identifier: "separator",
            label: "分隔符",
            type: "string",
        },
    ],
};
