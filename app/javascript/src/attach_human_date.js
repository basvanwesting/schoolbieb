import moment from 'moment'

export default class AttachHumanDate {
  static init() {
    $('[data-time]').each(function(i) {
      const time = moment($(this).data('time'))
      // LL means only date: TODO: Make default LLL since there is a data-date option
      const momentFormat = $(this).data('format') || 'LL'
      return $(this).text(time.format(momentFormat))
    })

    // Display date
    $('[data-date]').each(function(i) {
      const time = moment($(this).data('time'))
      // LL means only date
      const momentFormat = $(this).data('format') || 'LL'
      return $(this).text(time.format(momentFormat))
    })
  }
}
