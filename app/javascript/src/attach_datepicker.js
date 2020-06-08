export default class AttachDatepicker {
  static init() {
    $('input.datepicker').each(function(_index) {
      const el = $(this)
      // console.log(`init datepicker ${el}`)
      const options = { dateFormat: 'yy-mm-dd' }
      el.datepicker(options)
    })
  }

  static teardown() {
    $('input.hasDatepicker').each(function(_index) {
      const el = $(this)
      // console.log(`teardown datepicker ${el}`)
      el.datepicker('destroy')
    })
  }
}
