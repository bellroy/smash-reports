class OrganizationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def index
    respond_with(@organizations = current_user.organizations.all)
  end
end
