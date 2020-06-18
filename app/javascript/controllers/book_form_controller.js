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
          console.log("AutocompleteChannel:BookForm connected")
        },
        disconnected() {
          // Called when the subscription has been terminated by the server
          console.log("AutocompleteChannel:BookForm disconnected")
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
              console.log('Unknown action for AutocompleteChannel:BookForm#received', data)
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

  refreshTitleOptions() {
    this.autocompleteChannel.search_book_title({ title_cont: this.titleTarget.value })
  }
  debouncedRefreshTitleOptions = debounce(this.refreshTitleOptions, 300)

  setTitleOptions(titles) {
    if (titles.length === 1 && titles[0] === this.titleTarget.value) {
      $(this.titleListTarget)
        .empty()
    } else if (titles.length < RESULT_LIMIT) {
      const newOptions = titles.map(title => {
        const opt = document.createElement("option")
        opt.value = title
        return opt
      })
      $(this.titleListTarget)
        .empty()
        .append(newOptions)
    } else {
      const opt = document.createElement("option")
      opt.value = this.titleTarget.value
      opt.text = 'Too many results, filter more'
      $(this.titleListTarget)
        .empty()
        .append(opt)
    }
  }

  ///////////////////// Book#series //////////////////

  refreshSeriesOptions() {
    this.autocompleteChannel.search_book_series({ series_cont: this.seriesTarget.value })
  }
  debouncedRefreshSeriesOptions = debounce(this.refreshSeriesOptions, 300)

  setSeriesOptions(series) {
    if (series.length === 1 && series[0] === this.seriesTarget.value) {
      $(this.seriesListTarget)
        .empty()
    } else if (series.length < RESULT_LIMIT) {
      const newOptions = series.map(series => {
        const opt = document.createElement("option")
        opt.value = series
        return opt
      })
      $(this.seriesListTarget)
        .empty()
        .append(newOptions)
    } else {
      const opt = document.createElement("option")
      opt.value = this.seriesTarget.value
      opt.text = 'Too many results, filter more'
      $(this.seriesListTarget)
        .empty()
        .append(opt)
    }
  }

  ///////////////////// AUTHOR //////////////////

  refreshAuthorOptions() {
    this.autocompleteChannel.search_author({ id_author_wildcard: this.authorDescriptionTarget.value })
  }
  debouncedRefreshAuthorOptions = debounce(this.refreshAuthorOptions, 300)

  setAuthorOptions(authors) {
    if (authors.length === 0) {
      this.authorIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = this.authorDescriptionTarget.value
      opt.text = 'No match'
      $(this.authorListTarget)
        .empty()
        .append(opt)
    } else if (authors.length === 1) {
      //console.log(`set author_id to ${authors[0].id}`)
      this.authorIdTarget.value = authors[0].id
      this.authorDescriptionTarget.value = authors[0].description
      $(this.authorListTarget)
        .empty()
    } else if (authors.length < RESULT_LIMIT) {
      this.authorIdTarget.value = ''
      const newOptions = authors.map(author => {
        const opt = document.createElement("option")
        opt.value = author.description
        return opt
      })
      $(this.authorListTarget)
        .empty()
        .append(newOptions)
    } else {
      this.authorIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = this.authorDescriptionTarget.value
      opt.text = 'Too many results, filter more'
      $(this.authorListTarget)
        .empty()
        .append(opt)
    }
  }
}
