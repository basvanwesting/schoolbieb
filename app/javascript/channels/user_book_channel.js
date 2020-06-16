import consumer from "./consumer"

consumer.subscriptions.create({channel: "UserChannel", room: "Book"}, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("UserBookChannel connected")

    setTimeout(this.search.bind(this), 3000)
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("UserBookChannel disconnected")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(`UserBookChannel received: ${data}`)
  },

  search() {
    // Calls `AppearanceChannel#away` on the server.
    this.perform("search_book")
  },
})
