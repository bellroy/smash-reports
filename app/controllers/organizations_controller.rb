class OrganizationsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html

  def index
    @organizations = current_user.organizations.all
    respond_with(@organizations) do |format|
      format.html {
        if @organizations.size == 1
          redirect_to organization_reports_url(@organizations.first)
        end
      }
    end
  end
end
