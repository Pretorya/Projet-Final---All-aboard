class ResourcesController < ApplicationController
  before_action :authenticate_user!

  def index
    @search_query = params[:q].to_s.strip
    @resources = Resource.includes(:user, :subject, :tags).published.order(created_at: :desc)

    if @search_query.present?
      q = "%#{ActiveRecord::Base.sanitize_sql_like(@search_query)}%"
      matching_ids = Resource.published
                             .joins("LEFT JOIN subjects ON subjects.id = resources.subject_id")
                             .left_joins(:tags)
                             .where(
                               "resources.title LIKE :q OR resources.body LIKE :q OR subjects.name LIKE :q OR tags.name LIKE :q",
                               q: q
                             )
                             .distinct
                             .pluck(:id)
      @resources = @resources.where(id: matching_ids)
    end
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = current_user.resources.build(resource_params.except(:tag_list))
    @resource.status = (current_user.admin? || current_user.mentor?) ? :published : :pending

    if @resource.save
      @resource.sync_tags!(resource_params[:tag_list])

      if current_user.admin?
        redirect_to admin_dashboard_path, notice: "Ressource publiée."
      elsif current_user.mentor?
        redirect_to mentor_dashboard_path, notice: "Ressource publiée."
      else
        redirect_to resources_path, notice: "Ressource soumise — elle sera visible après validation par un mentor ou un admin."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :body, :subject_id, :tag_list)
  end
end
