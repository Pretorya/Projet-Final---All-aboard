class ResourcesController < ApplicationController
  before_action :authenticate_mentor!, only: [:new, :create]

  def index
    @resources = Resource.includes(:user, :subject).order(created_at: :desc)
  end

  def show
    @resource = Resource.find(params[:id])
  end

  def new
    @resource = Resource.new
  end

  def create
    @resource = current_user.resources.build(resource_params)
    if @resource.save
      redirect_to mentor_dashboard_path, notice: "Ressource publiée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def resource_params
    params.require(:resource).permit(:title, :body, :subject_id)
  end
end
