export default class BrowserTabSessionId {
  static init() {
    if (sessionStorage) {
      const btsi = sessionStorage.getItem('btsi') || $('meta[name=btsi]').attr("content")
      if (btsi) { sessionStorage.setItem('btsi', btsi) }
    }
  }

  static get id() {
    return sessionStorage.getItem('btsi')
  }

}
