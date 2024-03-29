$(document).ready(function(){
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
    control.makeTransliteratable(["hindi_article_search_term"]);
  }
  google.setOnLoadCallback(onLoad);
});