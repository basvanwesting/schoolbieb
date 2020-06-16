import { Controller } from "stimulus"
import consumer from "../channels/consumer"
import { debounce } from "lodash"

export default class extends Controller {
  static get targets() {
    return [
      "title",
      "titleList",
      "author",
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
        bookFormController.setTitleOptions(data)
      },
      search_title(filter) {
        // Calls `AppearanceChannel#away` on the server.
        this.perform("search_title", filter)
      },
    })
  }

  ///////////////////// Book#title //////////////////

  inputTitle() {
    console.log('call inputTitle')
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

  ///////////////////// AUTHOR //////////////////

  inputAuthor() {
    if (this.authorTarget.value.length > 1) {
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
    this.clearAuthorOptions()
    if (data.length === 1 && data[0].id == this.authorTarget.value) { return }

    data.forEach(author => {
      console.log(author)
      const opt = document.createElement("option")
      opt.value = author.id
      opt.text = author.full_name
      this.authorListTarget.appendChild(opt)
    })
  }

  updateAuthorOptions() {
    this.authorAutocompleteChannel.search({ last_name_cont: this.authorTarget.value })
  }
}
