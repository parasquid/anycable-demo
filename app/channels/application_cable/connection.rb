module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = User.where(id: cookies.signed[:user_id]).first
      reject_unauthorized_connection unless current_user
    end
  end
end
