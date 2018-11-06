class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  def user_name
    user.name
  end
end
