export default class AttachCollapsibleContainer {
  static init() {
    const collapsibleContainers = $('.collapsible-container')
    collapsibleContainers.each((i, el) => $(el).children('.collapsible-title').click(() => $(el).toggleClass('collapsed')))

    $('.collapsible-expand-all').dblclick(function() {
      if ($(this).hasClass('opened')) {
        collapsibleContainers.addClass('collapsed')
        $(this).removeClass('opened')
      } else {
        collapsibleContainers.removeClass('collapsed')
        $(this).addClass('opened')
      }
    })
  }
}
