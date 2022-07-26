$(document).ready(function(){
  google.load("elements", "1", {
    packages: "transliteration"
  });
  var elements_length;
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
    var elements = document.getElementsByClassName("article-comment-input");
    elements_length = elements.length;
    control.makeTransliteratable(elements);
    setInterval(() =>{
      control.makeTransliteratable(document.getElementsByClassName("article-comment-input"));
    }, 2000);
  }
  google.setOnLoadCallback(onLoad);
});