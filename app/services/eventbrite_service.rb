class EventbriteService
  BASE_URL = "https://app.ticketmaster.com"

  SUBJECT_KEYWORDS = {
    "ruby"          => ["ruby", "rails"],
    "javascript"    => ["javascript", "js", "node", "react", "vue", "typescript"],
    "python"        => ["python", "django", "data science", "machine learning", "ia ", "intelligence artificielle"],
    "algorithmie"   => ["algorithme", "hackathon", "competitive"],
    "html-css"      => ["html", "css", "web design", "frontend"],
    "sql"           => ["sql", "base de données", "database"],
    "devops"        => ["devops", "docker", "kubernetes", "cloud", "linux"],
    "cybersecurite" => ["cybersécurité", "cybersecurity", "hacking", "pentest"]
  }.freeze

  SEARCH_QUERIES = [
    "hackathon",
    "developer",
    "conference",
    "tech summit",
    "coding",
    "startup",
    "digital",
    "data science",
    "artificial intelligence",
    "cybersecurity",
    "open source",
    "web development"
  ].freeze

  def initialize
    @api_key = ENV["TICKETMASTER_API_KEY"]
    @conn = Faraday.new(url: BASE_URL) do |f|
      f.response :json
      f.adapter  Faraday.default_adapter
    end
  end

  def fetch_and_store_candidates
    return if @api_key.blank?

    SEARCH_QUERIES.each do |query|
      results = search_events(query)
      results.each { |event_data| store_candidate(event_data) }
    end
  end

  private

  def search_events(query)
    response = @conn.get("/discovery/v2/events.json") do |req|
      req.params["apikey"]        = @api_key
      req.params["keyword"]       = query
      req.params["size"]          = 20
      req.params["startDateTime"] = Time.current.strftime("%Y-%m-%dT%H:%M:%SZ")
      req.params["sort"]          = "date,asc"
    end

    return [] unless response.success?

    response.body.dig("_embedded", "events") || []
  rescue Faraday::Error
    []
  end

  TECH_KEYWORDS = %w[
    tech developer coding hackathon startup digital software hardware
    data science ai machine learning cyber security devops cloud
    programming javascript python ruby java web mobile app
    open source blockchain fintech edtech conference summit forum
    bootcamp workshop formation numérique informatique
  ].freeze

  def relevant?(title, description)
    text = "#{title} #{description}".downcase
    TECH_KEYWORDS.any? { |kw| text.include?(kw) }
  end

  def store_candidate(data)
    external_id = data["id"].to_s
    return if external_id.blank?
    return if EventCandidate.exists?(source: "ticketmaster", external_id: external_id)

    title       = data["name"].to_s.truncate(255)
    description = data.dig("info").to_s.presence || data.dig("pleaseNote").to_s
    return unless relevant?(title, description)
    starts_at   = parse_time(data.dig("dates", "start", "dateTime") || data.dig("dates", "start", "localDate"))
    url         = data["url"].to_s
    online      = data.dig("online_event") == true

    venue      = data.dig("_embedded", "venues", 0)
    location   = extract_location(venue)
    organizer  = data.dig("promoter", "name").to_s.presence ||
                 data.dig("_embedded", "attractions", 0, "name").to_s.presence

    EventCandidate.create!(
      source:       "ticketmaster",
      external_id:  external_id,
      title:        title.presence || "(sans titre)",
      description:  description,
      event_type:   detect_event_type(title, description),
      starts_at:    starts_at,
      location:     location,
      online:       online,
      external_url: url,
      organizer:    organizer,
      subject_id:   detect_subject_id(title, description),
      status:       "pending",
      raw_data:     data.to_json
    )
  rescue ActiveRecord::RecordInvalid
    nil
  end

  def extract_location(venue)
    return nil if venue.nil?

    [
      venue.dig("name"),
      venue.dig("city", "name"),
      venue.dig("state", "name")
    ].compact.reject(&:blank?).join(", ")
  end

  def detect_event_type(title, description)
    text = "#{title} #{description}".downcase
    return "hackathon"  if text.include?("hackathon")
    return "open_house" if text.match?(/portes? ouvertes?|open day|journée découverte/)
    return "conference" if text.match?(/conférence|conference|summit|forum/)
    return "meetup"     if text.include?("meetup")
    return "webinar"    if text.match?(/webinar|webinaire|en ligne|online/)
    "other"
  end

  def detect_subject_id(title, description)
    text = "#{title} #{description}".downcase
    SUBJECT_KEYWORDS.each do |slug, keywords|
      return Subject.find_by(slug: slug)&.id if keywords.any? { |kw| text.include?(kw) }
    end
    nil
  end

  def parse_time(str)
    return nil if str.blank?
    Time.parse(str)
  rescue StandardError
    nil
  end
end
