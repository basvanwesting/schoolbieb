import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

const RESULT_LIMIT = 25
export default class BookFormController extends Controller {

  static get targets() {
    return [
      "title",
      "titleList",
      "series",
      "seriesList",
      "authorId",
      "authorDescription",
      "authorList",
    ]
  }

  connect() {
    const bookFormController = this

    this.autocompleteChannel = consumer.subscriptions.create(
      { channel: "AutocompleteChannel", room: 'BookForm' },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          console.log("AutocompleteChannel connected")
        },
        disconnected() {
          // Called when the subscription has been terminated by the server
          console.log("AutocompleteChannel disconnected")
        },
        received(data) {
          console.log('AutocompleteChannel:BookForm received', data)
          switch(data.action) {
            case 'search_book_title':
              bookFormController.setTitleOptions(data.titles)
              break
            case 'search_book_series':
              bookFormController.setSeriesOptions(data.series)
              break
            case 'search_author':
              bookFormController.setAuthorOptions(data.authors)
              break
            default:
              console.log('Unknown action for AutocompleteChannel#received', data)
          }
        },
        search_book_title(filter) {
          this.perform("search_book_title", filter)
        },
        search_book_series(filter) {
          this.perform("search_book_series", filter)
        },
        search_author(filter) {
          this.perform("search_author", filter)
        },
      }
    )
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
    this.autocompleteChannel.search_book_title({ title_cont: this.titleTarget.value })
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
    this.autocompleteChannel.search_book_series({ series_cont: this.seriesTarget.value })
  }

  ///////////////////// AUTHOR //////////////////

  inputAuthor() {
    if (this.authorDescriptionTarget.value.length > 1) {
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

  setAuthorOptions(authors) {
    if (authors.length === 1 && authors[0].description === this.authorDescriptionTarget.value) {
      console.log(`set author_id to ${authors[0].id}`)
      this.authorIdTarget.value = authors[0].id
      this.clearAuthorOptions()
    } else if (authors.length >= RESULT_LIMIT) {
      this.authorIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = `${this.authorDescriptionTarget.value}... Too many results (${authors.length}), type more`
      $(this.authorListTarget)
        .empty()
        .append(opt)
    } else {
      this.authorIdTarget.value = ''
      const newOptions = authors.map(author => {
        const opt = document.createElement("option")
        opt.value = author.description
        //opt.setAttribute("author_id", author.id)
        return opt
      })
      $(this.authorListTarget)
        .empty()
        .append(newOptions)
    }
  }

  updateAuthorOptions() {
    this.autocompleteChannel.search_author({ id_author_wildcard: this.authorDescriptionTarget.value })
  }
}
