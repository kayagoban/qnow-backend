class UsersController < ApplicationController

  def create
    user = User.create
    session[:current_user_id] = user.id
    user.session_id = session.id
    render status: 200
  end

  def new
    # render new page with
    # name and queue length
  end

  def index
    binding.pry
    render status: 200
  end

  def enqueue
    #binding.pry
    render status: 200
  end

  def slots
    #binding.pry
    render status: 200
  end

end
