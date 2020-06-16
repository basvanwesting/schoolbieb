import consumer from "./consumer"

consumer.subscriptions.create("UserChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("UserChannel connected")

    setTimeout(this.search.bind(this), 4000)
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("UserChannel disconnected")
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(`UserChannel received: ${data}`)
  },

  search() {
    // Calls `AppearanceChannel#away` on the server.
    this.perform("search")
  },
})
