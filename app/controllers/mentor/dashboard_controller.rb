class Mentor::DashboardController < Mentor::BaseController
  def index
    @resources = current_user.resources.includes(:subject).order(created_at: :desc)
    @pending_resources = Resource.includes(:user, :subject, :tags)
                                 .pending
                                 .where(subject_id: current_user.competences.pluck(:id))
                                 .order(created_at: :asc)
  end
end
