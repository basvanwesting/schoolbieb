export default class BrowserTabSessionId {
  static init() {
    if (sessionStorage) {
      const btsi = sessionStorage.getItem('btsi') || BrowserTabSessionId.generateId()
      if (btsi) { sessionStorage.setItem('btsi', btsi) }
    }
  }

  static generateId() {
    return Math.floor(Math.random() * 0xFFFFFFFF).toString(16)
  }

  static get id() {
    return sessionStorage.getItem('btsi')
  }

}
