class Admin::DashboardController < Admin::BaseController
  def index
    @total_posts = Post.count
    @total_users = User.count
    @pending_subject_requests = SubjectRequest.where(status: "pending").count
    @pending_event_candidates = EventCandidate.pending.count
    @recent_posts = Post.recent_first.limit(10)
  end
end
