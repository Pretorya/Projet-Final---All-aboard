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
    validate :no_profanity
  end

  private

  def profanity_fields
    []
  end

  def no_profanity
    profanity_fields.each do |field|
      value = send(field).to_s
      next if value.blank?

      if value.match?(BANNED_REGEX)
        errors.add(field, :profanity, message: "contient un langage inapproprié")
      end
    end
  end
end
