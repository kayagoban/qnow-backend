class UsersController < ApplicationController

  before_action :user_login

  def known_merchants
  end

  def enqueue
    begin
      merchant = User.find_by_join_code(params.require(:join_code))
    rescue ActionController::ParameterMissing
      render(json: {}.to_json, status: 404) and return
    end
    @queue_slot = @user.joined_queue_slots.create(merchant: merchant)

    if @queue_slot.invalid?
      render(json: {  }.to_json, status: 404)
    end
  end

  def dequeue
    begin
      merchant = User.find(params.require(:id))
    rescue ActionController::ParameterMissing
      render(json: {}.to_json, status: 404) and return
    end
 
    q_slots = @user.joined_queue_slots.where(merchant: merchant)

    if q_slots.empty?
      render(json: {}.to_json, status: 404) and return
    else
      @user.joined_queue_slots.delete(q_slots)
      render(json: {}.to_json, status: 200) and return
    end

  end

  def slots
    binding.pry
    render status: 200
  end

end
