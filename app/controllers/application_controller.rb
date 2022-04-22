class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  protected

  public def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:user_image])
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end

  def after_sign_up_path_for(resource)
    redirect_to profile_path(current_user)
  end

  private

  def delete_from_aws(keyId)
    s3 = Aws::S3::Client.new(
      region: "eu-north-1",
      access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
      secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key)
    )
    s3.delete_object(bucket: 'rorbua', key: keyId)
  end
end

