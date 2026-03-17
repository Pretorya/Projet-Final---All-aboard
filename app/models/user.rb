class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :subject_requests, dependent: :destroy

  validates :full_name, presence: true

  before_validation :populate_full_name, on: :create

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def display_name
    full_name.presence || email.split("@").first.titleize
  end

  def profile_avatar
    avatar_url.presence || "https://ui-avatars.com/api/?background=6366f1&color=ffffff&name=#{ERB::Util.url_encode(display_name)}"
  end

  def initials
    display_name.split.map { |part| part.first }.join.first(2).upcase
  end

  def contribution_count
    comments.size + messages.size
  end

  def unread_messages_count
    conversation_participants.includes(conversation: :messages).sum do |participant|
      participant.conversation.unread_count_for(self)
    end
  end

  private

  def populate_full_name
    self.full_name = email.split("@").first.titleize if full_name.blank? && email.present?
  end
end
