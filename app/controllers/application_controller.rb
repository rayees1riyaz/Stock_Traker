class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  stale_when_importmap_changes
   helper_method :current_user

  def current_user
    return @current_user if @current_user

    if session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
    end
  end
   def require_login
    redirect_to login_path, alert: "Please login first" unless current_user
  end
end
