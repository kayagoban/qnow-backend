class ApplicationController < ActionController::Base

  include ActionController::MimeResponds

  def user_login
    if session['user_id'].nil?
      @user = User.create
      session['user_id'] = @user.id
    else
      @user = User.find(session['user_id'])
    end
    
  end
 
end
