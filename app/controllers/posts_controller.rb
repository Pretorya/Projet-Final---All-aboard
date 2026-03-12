class PostsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = current_user.posts.build(post_params.except(:tag_list))

    if @post.save
      @post.sync_tags!(post_params[:tag_list])
      redirect_to authenticated_root_path, notice: "Requête publiée avec succès."
    else
      redirect_to authenticated_root_path, alert: @post.errors.full_messages.to_sentence
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :code_snippet, :subject_id, :urgent, :education_level, :tag_list)
  end
end
