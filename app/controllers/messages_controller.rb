class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @conversation = current_user.conversations.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params.merge(user: current_user))

    if @message.save
      @conversation.mark_read_for!(current_user)

      respond_to do |format|
        format.turbo_stream { head :ok }
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      respond_to do |format|
        format.turbo_stream { head :unprocessable_entity }
        format.html { redirect_to conversation_path(@conversation), alert: @message.errors.full_messages.to_sentence }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
