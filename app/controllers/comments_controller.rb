class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.includes(:user, :subject, :tags, comments: :user, likes: :user, bookmarks: :user).find(comment_params[:post_id])
    @comment = @post.comments.build(body: comment_params[:body], user: current_user)

    if @comment.save
      render turbo_stream: turbo_stream.replace(
        view_context.dom_id(@post, :card),
        partial: "posts/post",
        locals: { post: @post.reload }
      )
    else
      redirect_to authenticated_root_path, alert: @comment.errors.full_messages.to_sentence
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:post_id, :body)
  end
end
