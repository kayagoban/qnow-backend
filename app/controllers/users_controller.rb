class UsersController < ApplicationController 
  #before_action :require_user_login, only: [:known_merchants, :status]
  #before_action :create_user_login, only: [:transfer_code, :add_merchant, :enqueue, :dequeue, :enable_queue, :disable_queue, :transfer]

  before_action :create_user_login
  
  def known_merchants
  end

  def status
    if stale?(etag: @user, last_modified: @user.updated_at)
      @merchant_joins = @user.known_merchant_joins.includes(:merchant)
      respond_to do |format|
        format.html # show.html.erb
        #format.json { render json: @company }
      end
    end
  end

  def transfer_code
    render(json: { transfer_code: @user.transfer_code }.to_json) and return
  end

  # This GET request mutates data on the 
  # server.  This isn't RESTy, but it is 
  # necessary to allow a QRcode URL to 
  # perform an action - to add a known
  # merchant to a user.
  #
  def add_queue
    #begin
      merchant = User.find_by_join_code(params.require(:id))
      #if @user.known_merchant_joins.where(merchant_id: params.require(:id)).count > 0
      #  redirect_to action: :status and return
      #end
      @mjoin = @user.known_merchant_joins.create(merchant: merchant)
      #if @mjoin.invalid?
      #  binding.pry
      #  raise Error
      #end
    #rescue
    #  render_404 and return
    #end

    redirect_to action: :status

  end

  def remove_queue
    begin
      merchant = User.find_by_join_code(params.require(:join_code))
    rescue ActionController::ParameterMissing
      # flash error and return
      render_404 and return
    end

    @user.known_merchants.delete(merchant)
    redirect_to action: :status
  end

  def join_queue 
    begin
      merchant = User.find_by_join_code(params.require(:join_code))
    rescue ActionController::ParameterMissing
      # flash error and return
      render_404 and return
    end

    if merchant.nil?
      # flash error and return
      render_404 and return
    end

    if not merchant.queue_enabled?
      # flash error and return
      render_404 and return
    end
 
    @queue_slot = @user.joined_queue_slots.create(merchant: merchant)

    #if @queue_slot.invalid?
    #  render_404 
    #end
    redirect_to action: :status
  end

  def exit_queue
    begin
      merchant = User.find_by_join_code(params.require(:join_code))
    rescue ActionController::ParameterMissing
      # flash error and return
      render_404 and return
    end

    if merchant.nil?
      # flash error and return
      render_404 and return
    end

    if not merchant.queue_enabled?
      # flash error and return
      render_404 and return
    end
 
    q_slots = @user.joined_queue_slots.where(merchant: merchant)

    @user.joined_queue_slots.delete(q_slots)
    redirect_to action: :status
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
    render(plain: '',status: 404)
  end

end
