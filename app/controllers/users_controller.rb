class UsersController < ApplicationController

  before_action :user_login

  def known_merchants
  end

  def enqueue
    merchant = User.find_by_join_code(params.require(:join_code))
    @queue_slot = @user.joined_queue_slots.create(merchant: merchant)

    if @queue_slot.invalid?
      render(json: {  }.to_json, status: 404)
    end
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
