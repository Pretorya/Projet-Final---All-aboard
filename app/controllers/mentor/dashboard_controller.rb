class Mentor::DashboardController < Mentor::BaseController
  def index
    @resources = current_user.resources.includes(:subject).order(created_at: :desc)
  end
end
