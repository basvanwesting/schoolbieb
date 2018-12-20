document.addEventListener("turbolinks:load", function() {
  $('select.js-select2').select2({
    theme: "foundation",
    allowClear: true,
    placeholder: ""
  })
})
