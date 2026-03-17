class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_shared_navigation

  helper_method :active_section

  protected

  def after_sign_in_path_for(_resource)
    authenticated_root_path
  end

  def after_sign_out_path_for(_resource_or_scope)
    root_path
  end

  def active_section
    case controller_name
    when "feed", "posts", "comments", "likes", "bookmarks"
      :feed
    when "explore"
      :explore
    when "conversations", "messages"
      :messages
    end
  end

  private

  def configure_permitted_parameters
    extra_keys = [ :full_name, :headline, :education_level, :bio, :avatar_url ]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_keys)
  end

  def load_shared_navigation
    return unless user_signed_in?

    @subjects = Subject.ordered
    @new_post = current_user.posts.build(education_level: current_user.education_level)
    @new_subject_request = current_user.subject_requests.build
    @conversation_count = current_user.unread_messages_count
  end
end
