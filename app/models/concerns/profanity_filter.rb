module ProfanityFilter
  extend ActiveSupport::Concern

  BANNED_WORDS = %w[
    connard connards connasse connasses
    enculé enculés enculée enculées encule encules
    putain putains
    salope salopes
    pute putes
    merde merdes
    bordel
    fdp
    ntm
    nique niquer niqué niqués
    baiser baiseur baiseuse
    foutre foutez
    bite bites
    chatte chattes
    couille couilles couillon couillons
    con cons conne connes
    cul culs
    salopard salopards saloparde
    ordure ordures
    pd
    tapette tapettes
    grosse
    nazi
    fuck fucker fucking
    shit
    bitch bitches
    asshole
    bastard bastards
    cunt
    dick dicks
    pussy
    nigger
  ].freeze

  BANNED_REGEX = Regexp.new(
    "\\b(#{BANNED_WORDS.map { |w| Regexp.escape(w) }.join("|")})\\b",
    Regexp::IGNORECASE
  )

  included do
    before_save :check_moderation
  end

  private

  def profanity_fields
    []
  end

  def check_moderation
    return if profanity_fields.empty?

    flagged = profanity_fields.any? do |field|
      value = send(field).to_s
      next false if value.blank?
      value.match?(BANNED_REGEX) || DenylistPattern.active.any? { |p| p.matches?(value) }
    end

    self.flagged_for_moderation = true if flagged
  end
end
