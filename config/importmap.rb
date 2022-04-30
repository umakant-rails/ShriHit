# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js", preload: true
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "layout", to: "layout.js", preload: true
# pin "transliteration", to: "transliteration.js", preload: true
# pin "summernote", to: "https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js", preload: true
# pin "tinymce", to: "https://cdn.tiny.cloud/1/no-api-key/tinymce/5/tinymce.min.js", preload: true

pin "tinymce", to: "tinymce.min.js", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
#pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.0.1/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-validation", to: "https://ga.jspm.io/npm:stimulus-validation@1.0.1-beta.3/dist/validation-controller.js"
pin "stimulus", to: "https://ga.jspm.io/npm:stimulus@1.1.1/dist/stimulus.umd.js"
pin "validate.js", to: "https://ga.jspm.io/npm:validate.js@0.12.0/validate.js"
pin "stimulus-autocomplete", to: "https://ga.jspm.io/npm:stimulus-autocomplete@3.0.2/src/autocomplete.js"

pin "article-custom";
pin "google-custom";

