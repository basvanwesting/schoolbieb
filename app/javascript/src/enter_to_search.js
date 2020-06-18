export default class EnterToSearch {
  static init() {
    const searchRow = $('tr.search')
    if (searchRow) {
      searchRow.on('keydown', e => {
        //console.log(e)
        if (e.which === 13) {
          const searchButton = $('#search_button')
          if (searchButton) {
            e.preventDefault()
            searchButton.focus()
            searchButton.click()
          }
        }
      })
    }
  }
}
