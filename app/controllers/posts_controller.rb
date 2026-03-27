class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :track_view, :destroy]
  before_action :authorize_admin!, only: [:destroy]

  def show
    record_view(@post.id)
  end

  def track_view
    record_view(@post.id)
    render turbo_stream: turbo_stream.replace(
      "recently_viewed",
      partial: "feed/recently_viewed",
      locals: { recently_viewed: recently_viewed_posts }
    )
  end

  def create
    @post = current_user.posts.build(post_params.except(:tag_list))

    if @post.save
      @post.sync_tags!(post_params[:tag_list])
      redirect_to authenticated_root_path, notice: "Requête publiée avec succès."
    else
      redirect_to authenticated_root_path, alert: @post.errors.full_messages.to_sentence
    end
  end

  def destroy
    @post.destroy
    redirect_to authenticated_root_path, notice: "Post supprimé avec succès."
  end

  private

  def set_post
    @post = Post.includes(:user, :subject, :tags, { comments: :user }, { likes: :user }, { bookmarks: :user }).find(params[:id])
  end

  def record_view(post_id)
    viewed = (session[:recently_viewed_post_ids] || []).map(&:to_i)
    viewed.prepend(post_id)
    viewed.uniq!
    session[:recently_viewed_post_ids] = viewed.first(4)
  end

  def recently_viewed_posts
    ids = (session[:recently_viewed_post_ids] || []).map(&:to_i)
    Post.includes(:user, :subject).where(id: ids).index_by(&:id).values_at(*ids).compact
  end

  def authorize_admin!
    redirect_to authenticated_root_path, alert: "Accès non autorisé" unless current_user.admin?
  end

  def post_params
    params.require(:post).permit(:title, :body, :code_snippet, :code_language, :subject_id, :urgent, :education_level, :tag_list)
  end
end
