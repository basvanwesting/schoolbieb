/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import 'core-js/stable'
import 'regenerator-runtime/runtime'

require("@rails/ujs").start()
require("turbolinks").start()

import './vendor'
import '../stylesheets/application'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.

//const images = require.context('../images', true)
//const imagePath = (name) => images(name, true)

import "@stimulus/polyfills"
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

// console.log('Hello World from Webpacker')

const application = Application.start()
const context = require.context("controllers", true, /.js$/)
application.load(definitionsFromContext(context))

import EnterToSearch              from '../src/enter_to_search'
import AttachSelect2              from '../src/attach_select2'
import AttachDatepicker           from '../src/attach_datepicker'
//import AttachHumanSize            from '../src/attach_human_size'
//import AttachHumanDate            from '../src/attach_human_date'
import AttachCollapsibleContainer from '../src/attach_collapsible_container'

document.addEventListener('turbolinks:load', function() {
  $(document).foundation()

  EnterToSearch.init()
  AttachSelect2.init()
  AttachDatepicker.init()
  //AttachHumanSize.init()
  //AttachHumanDate.init()
  AttachCollapsibleContainer.init()
})

document.addEventListener('turbolinks:before-cache', function() {
  $.datepicker.dpDiv.remove()
  AttachSelect2.teardown()
  AttachDatepicker.teardown()
})

document.addEventListener('turbolinks:before-render', function(event) {
  $.datepicker.dpDiv.appendTo(event.data.newBody)
})
