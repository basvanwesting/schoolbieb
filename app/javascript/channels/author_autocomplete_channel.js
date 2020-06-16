import consumer from "./consumer"

consumer.subscriptions.create("AuthorAutocompleteChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("AuthorAutocompleteChannel connected")

    setTimeout(this.search.bind(this), 5000)
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("AuthorAutocompleteChannel disconnected")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(`AuthorAutocompleteChannel received: ${data}`)
  },

  search() {
    // Calls `AppearanceChannel#away` on the server.
    this.perform("search")
  },
})
