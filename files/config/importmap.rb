# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin_all_from 'app/frontend/components/app', under: 'components/app', to: 'components/app'
pin_all_from 'app/frontend/components/general', under: 'components/general', to: 'components/general'
pin_all_from 'app/javascript/mixins', under: 'mixins'

pin 'slim-select', preload: false
pin 'flatpickr'
pin 'flatpickr/dist/l10n/ja.js', to: 'flatpickr--dist--l10n--ja.js.js'
