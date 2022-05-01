$(document).ready(function(){
  tinymce.init({
     selector: '.tinymce',
     height: 350,
     menubar: false,
     plugins: [
       'advlist autolink lists link image charmap print preview anchor',
       'searchreplace visualblocks code fullscreen',
       'insertdatetime media table paste code help wordcount'
     ],
       toolbar: 'undo redo | formatselect | ' +
       ' bold italic backcolor | alignleft aligncenter ' +
       ' alignright alignjustify | bullist numlist outdent indent | ' +
       ' removeformat | help'
   });

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
    control.makeTransliteratable(["article_hindi_title", "context", 
        "author", "article_content_ifr"]);
  }
  google.setOnLoadCallback(onLoad);

});