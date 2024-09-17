// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import { createConsumer } from "@rails/actioncable";

require("action_cable")
require("answers")
require("questions")
require("votes")
require("@oddcamp/cocoon-vanilla-js")

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.App = window.App || {}
window.App.cable = createConsumer()
