class RegistrationsController < Devise::RegistrationsController
  before_action only: [:destroy] do
    delete_from_aws("#{current_user.user_image.key}")
  end

  def destroy
    resource.destroy
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end

end