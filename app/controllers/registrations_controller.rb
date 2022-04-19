class RegistrationsController < Devise::RegistrationsController
  before_action only: [:destroy, :update] do
    if @user.user_image.attached?
      delete_from_aws("#{current_user.user_image.key}")
    end
  end
end