import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

const RESULT_LIMIT = 25
export default class extends Controller {

  static get targets() {
    return [
      "title",
      "titleList",
      "series",
      "seriesList",
      "authorId",
      "authorFullName",
      "authorList",
    ]
  }

  connect() {
    const bookFormController = this

    this.authorAutocompleteChannel = consumer.subscriptions.create("AuthorAutocompleteChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("AuthorAutocompleteChannel connected")
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("AuthorAutocompleteChannel disconnected")
      },
      received(data) {
        console.log(`AuthorAutocompleteChannel received: ${data}`)
        bookFormController.setAuthorOptions(data)
      },
      search(filter) {
        // Calls `AppearanceChannel#away` on the server.
        this.perform("search", filter)
      },
    })

    this.bookAutocompleteChannel = consumer.subscriptions.create("BookAutocompleteChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("BookAutocompleteChannel connected")
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("BookAutocompleteChannel disconnected")
      },
      received(data) {
        console.log(`BookAutocompleteChannel received: ${data}`)
        switch(data.action) {
          case 'search_title':
            bookFormController.setTitleOptions(data.titles)
            break
          case 'search_series':
            bookFormController.setSeriesOptions(data.series)
            break
          default:
            console.log(`Unknown action for BookAutocompleteChannel#received ${data}`)
        }
      },
      search_title(filter) {
        this.perform("search_title", filter)
      },
      search_series(filter) {
        this.perform("search_series", filter)
      },
    })
  }

  ///////////////////// Book#title //////////////////

  inputTitle() {
    if (this.titleTarget.value.length > 3) {
      this.updateTitleOptions()
    } else {
      this.clearTitleOptions()
    }
  }

  debouncedInputTitle = debounce(this.inputTitle, 300)

  clearTitleOptions() {
    while (this.titleListTarget.hasChildNodes()) {
      this.titleListTarget.removeChild(this.titleListTarget.firstChild)
    }
  }

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
  }

  updateTitleOptions() {
    this.bookAutocompleteChannel.search_title({ title_cont: this.titleTarget.value })
  }

  ///////////////////// Book#series //////////////////

  inputSeries() {
    if (this.seriesTarget.value.length > 2) {
      this.updateSeriesOptions()
    } else {
      this.clearSeriesOptions()
    }
  }

  debouncedInputSeries = debounce(this.inputSeries, 300)

  clearSeriesOptions() {
    while (this.seriesListTarget.hasChildNodes()) {
      this.seriesListTarget.removeChild(this.seriesListTarget.firstChild)
    }
  }

  setSeriesOptions(series) {
    if (series.length === 1 && series[0] === this.seriesTarget.value) {
      this.clearSeriesOptions()
    } else if (series.length >= RESULT_LIMIT) {
      const opt = document.createElement("option")
      opt.value = `${this.seriesTarget.value}... Too many results (${series.length}), type more`
      $(this.seriesListTarget)
        .empty()
        .append(opt)
    } else {
      const newOptions = series.map(v => {
        const opt = document.createElement("option")
        opt.value = v
        return opt
      })
      $(this.seriesListTarget)
        .empty()
        .append(newOptions)
    }
  }

  updateSeriesOptions() {
    this.bookAutocompleteChannel.search_series({ series_cont: this.seriesTarget.value })
  }

  ///////////////////// AUTHOR //////////////////

  inputAuthor() {
    if (this.authorFullNameTarget.value.length > 1) {
      this.updateAuthorOptions()
    } else {
      this.clearAuthorOptions()
    }
  }

  debouncedInputAuthor = debounce(this.inputAuthor, 300)

  clearAuthorOptions() {
    while (this.authorListTarget.hasChildNodes()) {
      this.authorListTarget.removeChild(this.authorListTarget.firstChild)
    }
  }

  setAuthorOptions(data) {
    if (data.length === 1 && data[0].full_name === this.authorFullNameTarget.value) {
      this.authorIdTarget.value = data[0].id
      this.clearAuthorOptions()
    } else if (data.length >= RESULT_LIMIT) {
      this.authorIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = `${this.authorFullNameTarget.value}... Too many results (${data.length}), type more`
      $(this.authorListTarget)
        .empty()
        .append(opt)
    } else {
      this.authorIdTarget.value = ''
      const newOptions = data.map(author => {
        const opt = document.createElement("option")
        opt.value = author.full_name
        //opt.setAttribute("author_id", author.id)
        return opt
      })
      $(this.authorListTarget)
        .empty()
        .append(newOptions)
    }
  }

  updateAuthorOptions() {
    this.authorAutocompleteChannel.search({ id_author_wildcard: this.authorFullNameTarget.value })
  }
}
