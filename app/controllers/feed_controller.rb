class FeedController < ApplicationController
  before_action :authenticate_user!

  def index
    @selected_subject = Subject.find_by(slug: params[:subject])
    @selected_tag = Tag.find_by(slug: params[:tag])

    @posts = Post.includes(:user, :subject, :tags, comments: :user, likes: :user, bookmarks: :user).recent_first
    @posts = @posts.where(subject: @selected_subject) if @selected_subject.present?
    @posts = @posts.joins(:tags).where(tags: { id: @selected_tag.id }).distinct if @selected_tag.present?

    @quick_tags = Tag.joins(:posts).distinct.ordered.limit(5)
    @trending_subjects = Subject.left_joins(:posts)
                                .group(:id)
                                .order(Arel.sql("COUNT(posts.id) DESC"))
                                .limit(3)
    @top_contributors = User.includes(:comments, :messages).to_a
                            .sort_by { |user| [ -user.contribution_count, -user.rating.to_f ] }
                            .first(3)
  end
end
