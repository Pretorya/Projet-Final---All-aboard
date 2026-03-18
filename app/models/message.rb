class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :conversation, touch: true
  belongs_to :user

  has_one_attached :attachment

  validates :body, presence: true, unless: -> { attachment.attached? }

  after_create_commit :broadcast_to_conversation

  private

  def broadcast_to_conversation
    conversation.users.where.not(id: user_id).each do |recipient|
      broadcast_append_to(
        [ conversation, recipient ],
        target: "#{dom_id(conversation)}_messages",
        partial: "messages/message",
        locals: { message: self }
      )
    end
  end
end
