class UsersController < ApplicationController

  #respond_to :json

  def known_merchants
    user_login
    #binding.pry
    #render status: 200, json: @user.known_merchants
  end

  def enqueue
    binding.pry
    render status: 200
  end

  def dequeue
    binding.pry
    render status: 200
  end

  def slots
    binding.pry
    render status: 200
  end

end
