import consumer from "channels/consumer"

const siteId = window.location.pathname.match(/\/sites\/(\d+)/)?.[1];
console.log(siteId)

consumer.subscriptions.create("SiteChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
