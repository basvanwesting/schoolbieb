import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

const RESULT_LIMIT = 25
export default class LendingBorrowFormController extends Controller {

  static get targets() {
    return [
      "bookSelect",
      "bookFilter",
      "lenderSelect",
      "lenderFilter",
    ]
  }

  connect() {
    const lendingBorrowFormController = this

    this.autocompleteChannel = consumer.subscriptions.create(
      { channel: "AutocompleteChannel", room: 'LendingBorrowForm' },
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
          console.log('AutocompleteChannel:LendingBorrowForm received', data)
          switch(data.action) {
            case 'search_book':
              lendingBorrowFormController.setBookOptions(data.books)
              break
            case 'search_lender':
              lendingBorrowFormController.setLenderOptions(data.lenders)
              break
            default:
              console.log('Unknown action for AutocompleteChannel#received', data)
          }
        },
        search_book(filter) {
          this.perform("search_book", filter)
        },
        search_lender(filter) {
          this.perform("search_lender", filter)
        },
      }
    )

    this.refreshBookOptions()
    this.refreshLenderOptions()
  }

  ///////////////////// BOOK //////////////////

  refreshBookOptions() {
    this.autocompleteChannel.search_book({ state_eq: 'available', id_book_wildcard: this.bookFilterTarget.value })
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

  ///////////////////// LENDER //////////////////

  refreshLenderOptions() {
    this.autocompleteChannel.search_lender({ id_lender_wildcard: this.lenderFilterTarget.value })
  }
  debouncedRefreshLenderOptions = debounce(this.refreshLenderOptions, 300)

  setLenderOptions(lenders) {
    if (lenders.length === 0) {
      const opt = document.createElement("option")
      opt.value = ''
      opt.text = 'No match'
      $(this.lenderSelectTarget)
        .empty()
        .append(opt)
        .prop('disabled', 'disabled')
    } else if (lenders.length === 1) {
      const opt = document.createElement("option")
      opt.value = lenders[0].id
      opt.text = lenders[0].description
      $(this.lenderSelectTarget)
        .empty()
        .append(opt)
        .prop('disabled', false)
    } else if (lenders.length < RESULT_LIMIT) {
      const opt = document.createElement("option")
      opt.value = ''
      opt.text = 'Select one of the below...'
      const newOptions = lenders.map(lender => {
        const opt = document.createElement("option")
        opt.value = lender.id
        opt.text = lender.description
        return opt
      })
      $(this.lenderSelectTarget)
        .empty()
        .append(opt)
        .append(newOptions)
        .prop('disabled', false)
    } else {
      const opt = document.createElement("option")
      opt.value = ''
      opt.text = 'Too many results, filter more'
      $(this.lenderSelectTarget)
        .empty()
        .append(opt)
        .prop('disabled', 'disabled')
    }
  }
}
