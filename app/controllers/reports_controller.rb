class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_organization

  respond_to :html
  respond_to :csv, :only => :show

  def index
    respond_with(@reports = @organization.reports.all)
  end

  def show
    @report = @organization.reports.find(params[:id])
    @report.field_values = params[:field_values]
    @report.execute
    respond_with @report do |format|
      format.csv { render :text => @report.to_csv }
    end
  end

  def new
    respond_with(@report = @organization.reports.build)
  end

  def edit
    respond_with(@report = @organization.reports.find(params[:id]))
  end

  def create
    respond_with([@organization, @report = @organization.reports.create(params[:report])])
  end

  def update
    respond_with([@organization, @report = @organization.reports.update(params[:id], params[:report])])
  end

  def destroy
    @report = @organization.reports.destroy(params[:id])
    respond_with(@report, :location => reports_url)
  end

  private
  def forbidden
    render :text => "Forbidden", :status => 403
    return false
  end

  def find_organization
    @organization = current_user.organizations.find_by_name params[:organization_id]
    forbidden unless @organization
  end
end
