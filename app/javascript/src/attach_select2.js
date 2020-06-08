export default class AttachSelect2 {
  static init() {
    $('select.js-select2').each(function(_index) {
      const el = $(this)
      const options = {
        theme: 'foundation',
        allowClear: true,
        placeholder: ""
      }
      // console.log(`init select2 ${el}`)
      el.select2(options)
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

    $("select.js-select2-free-tags").select2({
      theme: "foundation",
      //allowClear: true,
      multiple: true,
      tags: true,
      tokenSeparators: [',', ' '],
    })
  }

  static teardown() {
    $('select.select2-hidden-accessible').each(function(_index) {
      const el = $(this)
      // console.log(`teardown select2 ${el}`)
      el.select2('destroy')
    })
  }
}
