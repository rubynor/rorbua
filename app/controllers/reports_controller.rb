class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!, except: [:create]

  # GET /reports or /reports.json
  def index
    @reports = Report.where("status = 0")
  end

  def arkiv
    @reports = Report.where("status = 1")
  end

  # GET /reports/1 or /reports/1.json
  def show
  end

  # GET /reports/new
  def new
    @report = Report.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          turbo_stream.replace("report_container", partial: "reports/formStory", locals:{report: @report})
        ]
      end
    end
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports or /reports.json
  def create
    @report = Report.new(report_params)
    respond_to do |format|
      if @report.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("report_container", partial: "reports/partials/report_submitted")
          ]
        end
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("report_container", partial: "reports/formStory", locals:{report: Report.new, status: :unprocessable_entity})
          ]
        end
      end
    end
  end

  # PATCH/PUT /reports/1 or /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to report_url(@report), notice: "Report was successfully updated." }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1 or /reports/1.json
  def destroy
    @report.destroy

    respond_to do |format|
      format.html { redirect_to reports_url, notice: "Report was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.require(:report).permit(:tittle,:description, :status, :userId, :reportable_id, :reportable_type)
    end
end
