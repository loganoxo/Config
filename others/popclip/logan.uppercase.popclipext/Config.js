// #popclip
// name: Uppercase
// identifier: logan.uppercase
// description: Make the selected text ALL UPPERCASE.
// icon: "square filled AB"
// popclip version: 4151

exports.action = (input) => {
  popclip.pasteText(input.text.toUpperCase());
};
