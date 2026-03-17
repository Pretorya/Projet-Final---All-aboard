class AdminController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    @total_posts = Post.count
    @total_users = User.count
    @total_reports = 0
    @recent_posts = Post.recent_first.limit(10)
  end

  def posts
    @posts = Post.recent_first
  end

  def delete_post
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to admin_posts_path, notice: "Post supprimé avec succès."
  end

  def users
    @users = User.all.order(:created_at)
  end

  def send_message_form
    @users = User.where.not(id: current_user.id)
  end

  def send_message_to_user
    recipient = User.find(params[:user_id])
    conversation = Conversation.find_or_create_direct!(sender: current_user, recipient: recipient)
    message = conversation.messages.build(user: current_user, body: params[:message_body])

    if message.save
      redirect_to conversation_path(conversation), notice: "Message envoyé avec succès."
    else
      redirect_to admin_send_message_form_path, alert: "Erreur lors de l'envoi du message."
    end
  end

  def create_admin_form
    @user = User.new
  end

  def create_admin
    @user = User.new(admin_params)
    @user.role = "admin"

    if @user.save
      redirect_to admin_users_path, notice: "Compte administrateur créé avec succès. Email: #{@user.email}"
    else
      render :create_admin_form, alert: @user.errors.full_messages.to_sentence
    end
  end

  private

  def admin_params
    params.require(:user).permit(:email, :password, :password_confirmation, :full_name)
  end
end
