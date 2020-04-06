class MerchantsController < ApplicationController

  def create
    merchant = Merchant.create
    session[:current_user_id] = merchant.id
    merchant.session_id = session.id
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
