$(document).ready(function(){
  google.load("elements", "1", {
    packages: "transliteration"
  });
  function onLoad() {
    var options = {
        sourceLanguage:
            google.elements.transliteration.LanguageCode.ENGLISH,
        destinationLanguage:
            [google.elements.transliteration.LanguageCode.HINDI],
        shortcutKey: 'ctrl+g',
        transliterationEnabled: true
    };
    var control =
        new google.elements.transliteration.TransliterationControl(options);
    control.makeTransliteratable(["article_hindi_title", "context", "author", "article_content_ifr"]);
  }
  google.setOnLoadCallback(onLoad);
});

// google.load("elements", "1", { packages: "transliteration" });
// var control;
// function onLoad() {
//     var options = {
//         //Source Language
//         sourceLanguage: google.elements.transliteration.LanguageCode.ENGLISH,
//         // Destination language to Transliterate
//         destinationLanguage: [google.elements.transliteration.LanguageCode.HINDI],
//         shortcutKey: 'ctrl+g',
//         transliterationEnabled: true
//     };
//     control = new google.elements.transliteration.TransliterationControl(options);
//     control.makeTransliteratable(['article_hindi_title']);
// }
// google.setOnLoadCallback(onLoad);