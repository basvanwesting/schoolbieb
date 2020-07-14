export default class AttachSelect2 {
  static init() {
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
