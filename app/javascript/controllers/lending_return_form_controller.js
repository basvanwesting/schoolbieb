import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

const RESULT_LIMIT = 25
export default class LendingReturnFormController extends Controller {

  static get targets() {
    return [
      "bookSelect",
      "bookFilter",
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

    // issue resets prefilled form
    //this.refreshBookOptions()
  }

  ///////////////////// BOOK //////////////////

  refreshBookOptions() {
    this.autocompleteChannel.search_book({ state_eq: 'borrowed', id_book_wildcard: this.bookFilterTarget.value })
  }
  debouncedRefreshBookOptions = debounce(this.refreshBookOptions, 300)

  setBookOptions(books) {
    if (books.length === 0) {
      const opt = document.createElement("option")
      opt.value = ''
      opt.text = 'No match'
      $(this.bookSelectTarget)
        .empty()
        .append(opt)
        .prop('disabled', 'disabled')
    } else if (books.length === 1) {
      const opt = document.createElement("option")
      opt.value = books[0].id
      opt.text = books[0].description
      $(this.bookSelectTarget)
        .empty()
        .append(opt)
        .prop('disabled', false)
    } else if (books.length < RESULT_LIMIT) {
      const opt = document.createElement("option")
      opt.value = ''
      opt.text = 'Select one of the below...'
      const newOptions = books.map(book => {
        const opt = document.createElement("option")
        opt.value = book.id
        opt.text = book.description
        return opt
      })
      $(this.bookSelectTarget)
        .empty()
        .append(opt)
        .append(newOptions)
        .prop('disabled', false)
    } else {
      const opt = document.createElement("option")
      opt.value = ''
      opt.text = 'Too many results, filter more'
      $(this.bookSelectTarget)
        .empty()
        .append(opt)
        .prop('disabled', 'disabled')
    }
  }

}
