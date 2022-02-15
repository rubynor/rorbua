# Pin npm packages by running ./bin/importmap
pin "playscreen"
pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/custom", under: "custom"
pin "howler", to: "https://cdn.skypack.dev/howler"
pin "swiper", to: "https://cdnjs.cloudflare.com/ajax/libs/Swiper/8.0.5/swiper-bundle.min.js"
