document.addEventListener("DOMContentLoaded", function () {
  Vue.component("comment-form", {
    props: ["userId", "postId"],
    data() {
      return {
        comment: null
      }
    },
    template: `
      <form @submit="submit">
        <input v-model.trim="comment" type="textfield">
        <input type="submit" value="Submit Comment">
      </form>
    `,
    methods: {
      submit(e) {
        e.preventDefault();
        App.comments.perform("submit", {
          comment: this.comment,
          user_id: this.userId,
          post_id: this.postId
        });
        this.comment = "";
      }
    }
  })

  new Vue({
    el: "div#comments"
  })

});
