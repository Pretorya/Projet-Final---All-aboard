class Resource < ApplicationRecord
  belongs_to :user
  belongs_to :subject, optional: true

  validates :title, :body, presence: true
end
