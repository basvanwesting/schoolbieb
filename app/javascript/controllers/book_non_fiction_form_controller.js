import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"
import BrowserTabSessionId from '../src/browser_tab_session_id'

const RESULT_LIMIT = 25
export default class BookNonFictionFormController extends Controller {

  static get targets() {
    return [
      "title",
      "titleList",
      "series",
      "seriesList",
    ]
  }

  connect() {
    const bookNonFictionFormController = this

    this.autocompleteChannel = consumer.subscriptions.create(
      { channel: "AutocompleteChannel", room: BrowserTabSessionId.id },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          console.log("AutocompleteChannel:BookNonFictionForm connected")
        },
        disconnected() {
          // Called when the subscription has been terminated by the server
          console.log("AutocompleteChannel:BookNonFictionForm disconnected")
        },
        received(data) {
          console.log('AutocompleteChannel:BookNonFictionForm received', data)
          switch(data.action) {
            case 'search_book_non_fiction_title':
              bookNonFictionFormController.setTitleOptions(data.titles)
              break
            case 'search_book_non_fiction_series':
              bookNonFictionFormController.setSeriesOptions(data.series)
              break
            default:
              console.log('Unknown action for AutocompleteChannel:BookNonFictionForm#received', data)
          }
        },
        search_book_non_fiction_title(filter) {
          this.perform("search_book_non_fiction_title", filter)
        },
        search_book_non_fiction_series(filter) {
          this.perform("search_book_non_fiction_series", filter)
        },
      }
    )
  }

  ///////////////////// Book::Nonfiction#title //////////////////

  refreshTitleOptions() {
    this.autocompleteChannel.search_book_non_fiction_title({ title_cont: this.titleTarget.value })
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

  ///////////////////// Book::Nonfiction#series //////////////////

  refreshSeriesOptions() {
    this.autocompleteChannel.search_book_non_fiction_series({ series_cont: this.seriesTarget.value })
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

}
