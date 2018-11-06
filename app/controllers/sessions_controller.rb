class SessionsController < ApplicationController
  def create
    user = User.where(name: params[:session][:name]).first
    cookies.signed[:user_id] = user.id if user
    redirect_back(fallback_location: root_path)
  end

  def destroy
    cookies.delete(:user_id)
    redirect_back(fallback_location: root_path)
  end
end
