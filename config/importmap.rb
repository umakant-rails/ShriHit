# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js", preload: true
pin "popper", to: 'popper.js', preload: true
pin "bootstrap", to: 'bootstrap.min.js', preload: true
pin "layout", to: "layout.js", preload: true
