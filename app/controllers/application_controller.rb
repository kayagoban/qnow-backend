class ApplicationController < ActionController::Base

  include ActionController::MimeResponds

  def create_user_login
    begin
      @user = User.find(session['user_id'])
    rescue 
      @user = User.create
      session['user_id'] = @user.id
    end
  end

  def require_user_login
    begin
      @user = User.find(session['user_id'])
    rescue 
      render(json: {}.to_json, status: 401) and return
    end
  end

end
