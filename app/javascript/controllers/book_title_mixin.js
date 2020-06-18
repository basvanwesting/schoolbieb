import { debounce } from "lodash"
const RESULT_LIMIT = 25

export default {
  inputTitle() {
    if (this.titleTarget.value.length > 3) {
      this.updateTitleOptions()
    } else {
      this.clearTitleOptions()
    }
  },

  //debouncedInputTitle: debounce(this.inputTitle, 300),

  clearTitleOptions() {
    while (this.titleListTarget.hasChildNodes()) {
      this.titleListTarget.removeChild(this.titleListTarget.firstChild)
    }
  },

  setTitleOptions(titles) {
    if (titles.length === 1 && titles[0] === this.titleTarget.value) {
      this.clearTitleOptions()
    } else if (titles.length >= RESULT_LIMIT) {
      const opt = document.createElement("option")
      opt.value = `${this.titleTarget.value}... Too many results (${titles.length}), type more`
      $(this.titleListTarget)
        .empty()
        .append(opt)
    } else {
      const newOptions = titles.map(v => {
        const opt = document.createElement("option")
        opt.value = v
        return opt
      })
      $(this.titleListTarget)
        .empty()
        .append(newOptions)
    }
  },

  updateTitleOptions() {
    this.autocompleteChannel.search_book_title({ title_cont: this.titleTarget.value })
  }
}
