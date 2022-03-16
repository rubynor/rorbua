class LanguagesController < ApplicationController
  before_action :set_language, only: %i[ show edit update destroy ]

  # POST /languages or /languages.json
  def change
    puts "CCCCCCCCCCCCCCCCCCCCC #{params[:set_locale]}"
    session[:locale] = I18n.locale = params[:set_locale]
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_language
      @language = Language.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def language_params
      params.require(:language).permit(:name)
    end
end
