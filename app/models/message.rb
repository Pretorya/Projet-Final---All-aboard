class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :conversation, touch: true
  belongs_to :user

  validates :body, presence: true

  after_create_commit :broadcast_to_conversation

  private

  def broadcast_to_conversation
    broadcast_append_to(
      conversation,
      target: "#{dom_id(conversation)}_messages",
      partial: "messages/message",
      locals: { message: self }
    )
  end
end
