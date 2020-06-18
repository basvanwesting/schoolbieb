import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

const RESULT_LIMIT = 25
export default class LendingReturnFormController extends Controller {

  static get targets() {
    return [
      "bookId",
      "bookDescription",
      "bookList",
    ]
  }

  connect() {
    const lendingReturnFormController = this

    this.autocompleteChannel = consumer.subscriptions.create(
      { channel: "AutocompleteChannel", room: 'LendingReturnForm' },
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
          console.log('AutocompleteChannel:LendingReturnForm received', data)
          switch(data.action) {
            case 'search_book':
              lendingReturnFormController.setBookOptions(data.books)
              break
            default:
              console.log('Unknown action for AutocompleteChannel#received', data)
          }
        },
        search_book(filter) {
          this.perform("search_book", filter)
        },
      }
    )
  }

  ///////////////////// BOOK //////////////////

  refreshBookOptions() {
    this.autocompleteChannel.search_book({ state_eq: 'borrowed', id_book_wildcard: this.bookDescriptionTarget.value })
  }
  debouncedRefreshBookOptions = debounce(this.refreshBookOptions, 300)

  setBookOptions(books) {
    if (books.length === 0) {
      this.bookIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = this.bookDescriptionTarget.value
      opt.text = 'No match'
      $(this.bookListTarget)
        .empty()
        .append(opt)
    } else if (books.length === 1) {
      //console.log(`set book_id to ${books[0].id}`)
      this.bookIdTarget.value = books[0].id
      this.bookDescriptionTarget.value = books[0].description
      $(this.bookListTarget)
        .empty()
    } else if (books.length < RESULT_LIMIT) {
      this.bookIdTarget.value = ''
      const newOptions = books.map(book => {
        const opt = document.createElement("option")
        opt.value = book.description
        return opt
      })
      $(this.bookListTarget)
        .empty()
        .append(newOptions)
    } else {
      this.bookIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = this.bookDescriptionTarget.value
      opt.text = 'Too many results, filter more'
      $(this.bookListTarget)
        .empty()
        .append(opt)
    }
  }

}
