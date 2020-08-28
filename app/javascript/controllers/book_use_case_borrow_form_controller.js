import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce, deburr } from "lodash"
import BrowserTabSessionId from '../src/browser_tab_session_id'

const RESULT_LIMIT = 25
export default class BookUseCaseBorrowFormController extends Controller {

  static get targets() {
    return [
      "lenderId",
      "lenderDescription",
      "lenderList",
      "bookId",
      "bookDescription",
      "bookList",
    ]
  }

  connect() {
    const bookUseCaseBorrowFormController = this

    this.autocompleteChannel = consumer.subscriptions.create(
      { channel: "AutocompleteChannel", room: BrowserTabSessionId.id },
      {
        connected() {
          // Called when the subscription is ready for use on the server
          console.log("AutocompleteChannel:BookUseCaseBorrowForm connected")
        },
        disconnected() {
          // Called when the subscription has been terminated by the server
          console.log("AutocompleteChannel:BookUseCaseBorrowForm disconnected")
        },
        received(data) {
          console.log('AutocompleteChannel:BookUseCaseBorrowForm received', data)
          switch(data.action) {
            case 'search_book':
              bookUseCaseBorrowFormController.setBookOptions(data.books)
              break
            case 'search_lender':
              bookUseCaseBorrowFormController.setLenderOptions(data.lenders)
              break
            default:
              console.log('Unknown action for AutocompleteChannel:BookUseCaseBorrowForm#received', data)
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
  }

  ///////////////////// BOOK //////////////////

  refreshBookOptions() {
    this.autocompleteChannel.search_book({ state_eq: 'available', id_book_wildcard: this.bookDescriptionTarget.value })
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
    } else if (books.length === 1 && books[0].description == this.bookDescriptionTarget.value) {
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
        opt.text = deburr(book.description)
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

  ///////////////////// LENDER //////////////////

  refreshLenderOptions() {
    this.autocompleteChannel.search_lender({ id_lender_wildcard: this.lenderDescriptionTarget.value })
  }
  debouncedRefreshLenderOptions = debounce(this.refreshLenderOptions, 300)

  setLenderOptions(lenders) {
    if (lenders.length === 0) {
      this.lenderIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = this.lenderDescriptionTarget.value
      opt.text = 'No match'
      $(this.lenderListTarget)
        .empty()
        .append(opt)
    } else if (lenders.length === 1 && lenders[0].description == this.lenderDescriptionTarget.value) {
      //console.log(`set lender_id to ${lenders[0].id}`)
      this.lenderIdTarget.value = lenders[0].id
      this.lenderDescriptionTarget.value = lenders[0].description
      $(this.lenderListTarget)
        .empty()
    } else if (lenders.length < RESULT_LIMIT) {
      this.lenderIdTarget.value = ''
      const newOptions = lenders.map(lender => {
        const opt = document.createElement("option")
        opt.value = lender.description
        opt.text = deburr(lender.description)
        return opt
      })
      $(this.lenderListTarget)
        .empty()
        .append(newOptions)
    } else {
      this.lenderIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = this.lenderDescriptionTarget.value
      opt.text = 'Too many results, filter more'
      $(this.lenderListTarget)
        .empty()
        .append(opt)
    }
  }


}
