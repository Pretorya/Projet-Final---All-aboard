class EventsController < ApplicationController
  def index
    @events = Event.includes(:subject)

    if params[:subject_id].present?
      if params[:subject_id] == "general"
        @events = @events.where(subject_id: nil)
      else
        @events = @events.where(subject_id: params[:subject_id])
      end
    end

    @upcoming = @events.upcoming
    @past     = @events.past
  end

  def show
    @event = Event.find(params[:id])
  end
end
