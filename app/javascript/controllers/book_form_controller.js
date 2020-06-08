import { Controller } from "stimulus"
import { debounce } from "lodash"

export default class extends Controller {
  static get targets() {
    return [
      "title",
      "titleList",
    ]
  }

  inputTitle() {
    if (this.titleTarget.value.length > 3) {
      this.updateTitleOptions()
    } else {
      this.clearTitleOptions()
    }
  }

  debouncedInputTitle() {
    debounce(
      () => { this.inputTitle() },
      300
    )()
  }

  clearTitleOptions() {
    while (this.titleListTarget.hasChildNodes()) {
      this.titleListTarget.removeChild(this.titleListTarget.firstChild)
    }
  }

  setTitleOptions(values) {
    this.clearTitleOptions()
    if (values.length === 1 && values[0] === this.titleTarget.value) { return }

    values.forEach(v => {
      const opt = document.createElement("option")
      opt.value = v
      this.titleListTarget.appendChild(opt)
    })
  }

  updateTitleOptions() {
    fetch(
      `/titles?term=${this.titleTarget.value}`,
      { headers: { "Content-Type": "application/json; charset=utf-8", "Accept": "application/json" } },
    )
      .then(res => res.json())
      .then(response => this.setTitleOptions(response))
      .catch(err => console.log(err))
  }
}
