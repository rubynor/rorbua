class LanguagesController < ApplicationController

  # POST /languages or /languages.json
  def change
    session[:locale] = I18n.locale = params[:locale]
    redirect_back(fallback_location: root_path)
  end

  private

    # Only allow a list of trusted parameters through.
    def language_params
      params.require(:language).permit(:name)
    end
end
