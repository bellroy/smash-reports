module ApplicationHelper
  def current_organization
    @organization
  end

  def organizations
    return [] unless user_signed_in?
    current_user.organizations
  end
end
