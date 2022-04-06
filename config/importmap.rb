# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js", preload: true
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "layout", to: "layout.js", preload: true
#pin "transliteration", to: "transliteration.I.js", preload: true

pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-validation", to: "https://ga.jspm.io/npm:stimulus-validation@1.0.1-beta.3/dist/validation-controller.js"
pin "stimulus", to: "https://ga.jspm.io/npm:stimulus@1.1.1/dist/stimulus.umd.js"
pin "validate.js", to: "https://ga.jspm.io/npm:validate.js@0.12.0/validate.js"
