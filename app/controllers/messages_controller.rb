class MessagesController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_message, only: :destroy

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      @conversation.mark_read_for!(current_user)

      recipient = @conversation.other_participant(current_user)
      if recipient&.notify_on_message?
        NotificationMailer.new_message(recipient, @message).deliver_later
      end

      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "#{dom_id(@conversation)}_messages",
            partial: "messages/message",
            locals: { message: @message }
          )
        end
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to conversation_path(@conversation), alert: @message.errors.full_messages.to_sentence }
      end
    end
  end

  def destroy
    @conversation = @message.conversation
    @message.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(dom_id(@message))
      end
      format.html { redirect_to conversation_path(@conversation) }
    end
  end

  private

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:body, :attachment)
  end
end
