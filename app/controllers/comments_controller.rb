class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comment, only: :destroy

  def create
    @post = Post.includes(:user, :subject, :tags, comments: :user, likes: :user, bookmarks: :user).find(comment_params[:post_id])
    @comment = @post.comments.build(body: comment_params[:body], user: current_user)

    if @comment.save
      if @post.user != current_user && @post.user.notify_on_comment?
        NotificationMailer.new_comment(@post.user, @comment).deliver_later
      end

      render turbo_stream: [
        turbo_stream.replace(
          view_context.dom_id(@post, :card),
          partial: "posts/post",
          locals: { post: @post.reload }
        ),
        turbo_stream.append(
          "post_#{@post.id}_comments",
          partial: "comments/comment",
          locals: { comment: @comment }
        )
      ]
    else
      redirect_to authenticated_root_path, alert: @comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @post = @comment.post
    comment_id = dom_id(@comment)
    @comment.destroy
    render turbo_stream: [
      turbo_stream.replace(
        view_context.dom_id(@post, :card),
        partial: "posts/post",
        locals: { post: @post.reload }
      ),
      turbo_stream.remove(comment_id)
    ]
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:post_id, :body)
  end
end

