import "@hotwired/turbo-rails"
require("@rails/activestorage").start()
//require("trix")
//require("@rails/actiontext")
require("local-time").start()
require("@rails/ujs").start()

import './channels/**/*_channel.js'
import "./controllers"
