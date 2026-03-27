class NotificationMailer < ApplicationMailer
  default from: "noreply@studylink.app"

  def new_message(recipient, message)
    @recipient    = recipient
    @message      = message
    @sender       = message.user
    @conversation = message.conversation
    mail(to: recipient.email, subject: "💬 Nouveau message de #{@sender.display_name}")
  end

  def new_comment(recipient, comment)
    @recipient = recipient
    @comment   = comment
    @commenter = comment.user
    @post      = comment.post
    mail(to: recipient.email, subject: "💬 #{@commenter.display_name} a répondu à ton post")
  end
end
