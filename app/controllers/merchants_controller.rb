class MerchantsController < ApplicationController
  require 'pry'

  def create
    binding.pry
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
