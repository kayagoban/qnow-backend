class UsersController < ApplicationController 
  #before_action :require_user_login, only: [:known_merchants, :status]
  #before_action :create_user_login, only: [:transfer_code, :add_merchant, :enqueue, :dequeue, :enable_queue, :disable_queue, :transfer]

  before_action :create_user_login
  
  def known_merchants
  end

  def status
    @merchant_joins = @user.known_merchant_joins.includes(:merchant)
  end

  def transfer_code
    render(json: { transfer_code: @user.transfer_code }.to_json) and return
  end

  def add_merchant
    begin
      merchant = User.find_by_join_code(params.require(:join_code))
      @mjoin = @user.known_merchant_joins.create(merchant: merchant)
      if @mjoin.invalid?
        raise Error
      end
    rescue
      render_404 and return
    end

  end

  def enqueue
    begin
      merchant = User.find_by_join_code(params.require(:join_code))
    rescue ActionController::ParameterMissing
      render_404 and return
    end

    if merchant.nil?
      render_404 and return
    end

    if not merchant.queue_enabled?
      render_404 and return
    end
 
    @queue_slot = @user.joined_queue_slots.create(merchant: merchant)

    if @queue_slot.invalid?
      render_404 
    end
  end

  def dequeue
    begin
      merchant = User.find(params.require(:id))
    rescue ActionController::ParameterMissing
      render_404 and return
    end

    if merchant.nil?
      render_404 and return
    end

    if not merchant.queue_enabled?
      render_404 and return
    end
 
    q_slots = @user.joined_queue_slots.where(merchant: merchant)

    if q_slots.empty?
      render_404 and return
    else
      @user.joined_queue_slots.delete(q_slots)
      render(json: {}.to_json, status: 200) and return
    end
  end

  def enable_queue
    @user.queue_enabled = true
    @user.save
    render(json: {}.to_json, status: 200)
  end

  def disable_queue
    ActiveRecord::Base.transaction do
      @user.owned_queue_slots.delete_all
      @user.queue_enabled = false
      @user.save
    end
    render(json: {}.to_json, status: 200)
  end

  def transfer
    begin
      original_user = User.find_by_transfer_code(params.require(:transfer_code))
    rescue ActionController::ParameterMissing
      render_404 and return
    end

    if original_user.nil?
      render_404 and return
    end

    session['user_id'] = original_user.id 

    ActiveRecord::Base.transaction do
      original_user.transfer_code = SecureRandom.alphanumeric
      original_user.save
      @user.destroy
    end
  end

  def render_404
    render(json: {}.to_json, status: 404)
  end

end
