class CommentsChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    stream_from "posts:#{data["post_id"].to_i}:comments"
  end

  def unfollow
    stop_all_streams
  end

  def submit(data)
    user = User.find(data["user_id"])
    comment = Comment.create(
      user: user,
      post_id: data["post_id"],
      content: data["comment"],
    )

    ActionCable.server.broadcast(
      "posts:#{data["post_id"].to_i}:comments",
      comment.as_json(methods: :user_name)
    )
  end
end
