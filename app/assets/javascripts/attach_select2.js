document.addEventListener("turbolinks:load", function() {
  $('select.js-select2').select2({
    theme: "foundation",
    allowClear: true,
    placeholder: ""
  })

  $("select.js-select2-ajax").select2({
    theme: "foundation",
    allowClear: true,
    ajax: {
      dataType: "json",
      processResults: function (data) {
        return {
          results: data.map(function (item) { return { id: item, text: item } } )
        }
      }
    }
  })
})
