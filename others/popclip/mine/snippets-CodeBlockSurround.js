// #popclip 代码块包围
// name: CodeBlockSurround
// identifier: logan.CodeBlockSurround
// description: 将选中的文字用代码块```包围
// requirements: [text, paste]
// icon: square filled symbol:chevron.left.forwardslash.chevron.right
// language: javascript

popclip.pasteText("```\n" + popclip.input.text + "\n```\n", { restore: true });
