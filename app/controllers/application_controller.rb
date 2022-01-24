class ApplicationController < ActionController::Base
	rescue_from CanCan::AccessDenied do |exception|
		redirect_to root_url, alert: exception.message
    format.js { render status: :forbidden }
    format.json { render json: exception.message, status: :forbidden }
	end

	check_authorization
	skip_authorization_check if: :devise_controller?
end
