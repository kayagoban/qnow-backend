class MerchantsController < ApplicationController 
  before_action :create_user_login

  def manage
    if @user.queue_enabled?
      render 'status'
    else
      render 'show'
    end
  end

  def randomshit
    binding.pry
  end
  
  def empty_queue
    binding.pry
    ActiveRecord::Base.transaction do
      @user.owned_queue_slots.delete_all
    end
    render 'status'
  end

  def update
    binding.pry
    render 'status'
  end

  def queue_pdf
  end

  def reset_join_code
    render 'queue_pdf'
  end

  def show
  end

  def status
  end

  def disable_queue
    ActiveRecord::Base.transaction do
      @user.queue_enabled = false
      @user.save
    end
    render(json: {}.to_json, status: 200)
  end

  def render_404
    render(json: {}.to_json, status: 404)
  end

end
