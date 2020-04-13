class MerchantsController < ApplicationController 
  #before_action :require_user_login, only: [:known_merchants, :status]
  before_action :create_user_login #, only: [:transfer_code, :merchant, :enqueue, :dequeue, :enable_queue, :disable_queue, :transfer]
  
  def disable_queue
    ActiveRecord::Base.transaction do
      @user.owned_queue_slots.delete_all
      @user.queue_enabled = false
      @user.save
    end
    render(json: {}.to_json, status: 200)
  end

  def render_404
    render(json: {}.to_json, status: 404)
  end

end
