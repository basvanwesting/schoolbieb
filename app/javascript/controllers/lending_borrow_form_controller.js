import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

const RESULT_LIMIT = 25
export default class LendingBorrowFormController extends Controller {

  static get targets() {
    return [
      "bookId",
      "bookFullName",
      "bookList",
    ]
  }

  connect() {
    const lendingBorrowFormController = this

    this.autocompleteChannel = consumer.subscriptions.create("AutocompleteChannel", {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log("AutocompleteChannel connected")
      },
      disconnected() {
        // Called when the subscription has been terminated by the server
        console.log("AutocompleteChannel disconnected")
      },
      received(data) {
        console.log(`AutocompleteChannel received: ${data}`)
        switch(data.action) {
          case 'search_book':
            lendingBorrowFormController.setBookOptions(data.books)
            break
          default:
            console.log(`Unknown action for AutocompleteChannel#received ${data}`)
        }
      },
      search_book(filter) {
        this.perform("search_book", filter)
      },
    })
  }

  ///////////////////// BOOK //////////////////

  inputBook() {
    if (this.bookFullNameTarget.value.length > 1) {
      this.updateBookOptions()
    } else {
      this.clearBookOptions()
    }
  }

  debouncedInputBook = debounce(this.inputBook, 300)

  clearBookOptions() {
    while (this.bookListTarget.hasChildNodes()) {
      this.bookListTarget.removeChild(this.bookListTarget.firstChild)
    }
  }

  setBookOptions(books) {
    if (books.length === 1 && books[0].full_name === this.bookFullNameTarget.value) {
      console.log(`set book_id to ${books[0].id}`)
      this.bookIdTarget.value = books[0].id
      this.clearBookOptions()
    } else if (books.length >= RESULT_LIMIT) {
      this.bookIdTarget.value = ''
      const opt = document.createElement("option")
      opt.value = `${this.bookFullNameTarget.value}... Too many results (${books.length}), type more`
      $(this.bookListTarget)
        .empty()
        .append(opt)
    } else {
      this.bookIdTarget.value = ''
      const newOptions = books.map(book => {
        const opt = document.createElement("option")
        opt.value = book.full_name
        //opt.setAttribute("book_id", book.id)
        return opt
      })
      $(this.bookListTarget)
        .empty()
        .append(newOptions)
    }
  }

  updateBookOptions() {
    this.autocompleteChannel.search_book({ id_book_wildcard: this.bookFullNameTarget.value })
  }
}
