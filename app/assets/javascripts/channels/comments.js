App.comments = App.cable.subscriptions.create("CommentsChannel", {
  connected: function () {
    // Called when the subscription is ready for use on the server
    this.perform("follow", {
      post_id: document.querySelector("#comments").dataset.postId
    });
  },

  disconnected: function () {
    // Called when the subscription has been terminated by the server
    console.debug("comments channel disconnected")
  },

  received: function (data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
    const li = document.createElement("li");
    li.innerHTML = `${data.content} - ${data.user_name}`;
    document.querySelector(".comments").appendChild(li);
  }
});
