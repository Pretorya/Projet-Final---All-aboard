class AdminController < ApplicationController
  before_action :authenticate_admin!

  def dashboard
    @total_posts = Post.count
    @total_users = User.count
    @pending_subject_requests = SubjectRequest.where(status: "pending").count
    @recent_posts = Post.recent_first.limit(10)
  end

  def subject_requests
    @pending = SubjectRequest.where(status: "pending").ordered.includes(:user)
    @approved = SubjectRequest.where(status: "approved").ordered.includes(:user)
    @rejected = SubjectRequest.where(status: "rejected").ordered.includes(:user)
  end

  def update_subject_request
    @subject_request = SubjectRequest.find(params[:id])
    new_status = params[:status]
    if %w[approved rejected pending].include?(new_status) && @subject_request.update(status: new_status)
      redirect_to admin_subject_requests_path, notice: "Demande mise à jour."
    else
      redirect_to admin_subject_requests_path, alert: "Erreur lors de la mise à jour."
    end
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

  def promote_user
    @user = User.find(params[:id])
    if params[:admin] == "true"
      @user.update(role: "admin")
      redirect_to admin_users_path, notice: "Utilisateur #{@user.display_name} promu administrateur."
    elsif params[:admin] == "false"
      @user.update(role: "user")
      redirect_to admin_users_path, notice: "Utilisateur #{@user.display_name} rétrogradé utilisateur."
    else
      redirect_to admin_users_path, alert: "Action invalide."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_users_path, alert: "Utilisateur non trouvé."
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

  private
end
