class AuthenticatedController < ApplicationController
  before_action :set_session
  before_action :set_current_user

  protected

  def set_session
    @session = Session.new
  end

  def set_current_user
    if cookies.signed[:user_id]
      @current_user = User.find(cookies.signed[:user_id])
    end
  end
end
