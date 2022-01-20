class OauthCallbacksController < Devise::OmniauthCallbacksController
  def github
  	authenticate_with('Github')
  end

  def vkontakte
    authenticate_with("Vkontakte")
  end

  def authenticate_with(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Alarm'
    end
  end
end