# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_1 = User.where(name: "parasquid").first_or_create
post_1 = user_1.posts.create(
  title: "Jabberwocky",
  content: "'twas brillig, and the slithy toves",
  user: user_1,
)
post_1.comments.create(
  content: "did gyre and gimble in the wabe:",
  user: user_1,
)
post_1.comments.create(
  content: "all mimsy were the borogoves.",
  user: user_1,
)
post_1.comments.create(
  content: "and the mome raths outgrabe",
  user: user_1,
)

user_2 = User.where(name: "motionman").first_or_create
post_2 = user_2.posts.create(
  title: "Sonnet 18",
  content: "shall i compare thee to a summer's day?",
  user: user_2,
)
post_2.comments.create(
  content: "thou art more lovely an dmore temperate:",
  user: user_2,
)
post_2.comments.create(
  content: "rough winds do shake the darling buds of may,",
  user: user_2,
)
post_2.comments.create(
  content: "and summer's lease hath all too short a date:",
  user: user_2,
)
