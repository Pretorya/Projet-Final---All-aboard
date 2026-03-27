class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    current_user.likes.find_or_create_by!(post: post)
    replace_post(post)
  end

  def destroy
    like = current_user.likes.find(params[:id])
    post = like.post
    like.destroy
    replace_post(post)
  end

  alias_method :delete, :destroy

  private

  def replace_post(post)
    @post = Post.includes(:user, :subject, :tags, comments: :user, likes: :user, bookmarks: :user).find(post.id)
    render turbo_stream: turbo_stream.replace(
      view_context.dom_id(@post, :card),
      partial: "posts/post",
      locals: { post: @post }
    )
  end
end
