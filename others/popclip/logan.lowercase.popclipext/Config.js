// #popclip
// name: Lowercase
// identifier: logan.lowercase
// description: Make the selected text all lowercase.
// icon: square filled ab
// popclip version: 4151

exports.action = (input) => {
  popclip.pasteText(input.text.toLowerCase());
};
