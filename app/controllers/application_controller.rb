class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def after_sign_in_path_for(resource)
    return welcome_path unless profile_complete?(resource)
    super
  end

  def after_sign_up_path_for(resource)
    welcome_path
  end

  def profile_complete?(user)
    info = user.user_info
    return false unless info
    info.first_name.present? && info.last_name.present? && info.phone.present?
  end
end
