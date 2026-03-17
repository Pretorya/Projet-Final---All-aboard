class SubjectRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @subject_request = current_user.subject_requests.build(subject_request_params)

    if @subject_request.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "request-subject-modal",
            partial: "subject_requests/success_modal"
          )
        end
        format.html { redirect_to authenticated_root_path, notice: "Votre demande a été envoyée." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "request-subject-modal",
            partial: "subject_requests/modal",
            locals: { subject_request: @subject_request }
          )
        end
        format.html { redirect_to authenticated_root_path, alert: @subject_request.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def subject_request_params
    params.require(:subject_request).permit(:name, :description)
  end
end
