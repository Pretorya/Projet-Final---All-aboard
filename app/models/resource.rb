class Resource < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true
  has_many :resource_tags, dependent: :destroy
  has_many :tags, through: :resource_tags

  attr_accessor :tag_list

  enum :status, { pending: 0, published: 1, rejected: 2 }

  validates :title, :body, presence: true

  def sync_tags!(raw_tags)
    names = raw_tags.to_s.split(",").map(&:strip).reject(&:blank?).uniq.first(6)
    self.tags = names.map do |name|
      Tag.find_or_create_by!(slug: name.parameterize) { |t| t.name = name }
    end
  end
end
