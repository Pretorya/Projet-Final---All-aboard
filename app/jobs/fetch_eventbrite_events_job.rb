class FetchEventbriteEventsJob < ApplicationJob
  queue_as :default

  def perform
    EventbriteService.new.fetch_and_store_candidates
  end
end
