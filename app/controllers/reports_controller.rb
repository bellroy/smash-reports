class ReportsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_organization

  respond_to :html
  respond_to :csv, :only => :show

  def index
    respond_with(@organization, @reports = @organization.reports.all)
  end

  def show
    @report = @organization.reports.find_and_execute(params[:id], params[:field_values])
    respond_with @organization, @report do |format|
      format.csv { render :text => @report.to_csv }
    end
  end

  def new
    respond_with(@organization, @report = @organization.reports.build)
  end

  def edit
    respond_with(@organization, @report = @organization.reports.find(params[:id]))
  end

  def create
    respond_with(@organization, @report = @organization.reports.create(params[:report]))
  end

  def update
    respond_with(@organization, @report = @organization.reports.update(params[:id], params[:report]))
  end

  def destroy
    @report = @organization.reports.destroy(params[:id])
    respond_with(@organization, @report, :location => view_context.reports_url)
  end

  def revert
    @report = @organization.reports.find(params[:id])
    version = params[:report][:version]
    if version
      @report.versions.find(version).reify.save
    end
    respond_with(@organization, @report = @organization.reports.find(params[:id]))
  end

  def deleted
    all_versions = Version.all(:conditions => { :event => 'destroy',
                                                :item_type => Report.name})
                   .map {|v| [v.reify, v] }
    @versions = all_versions.select {|rv| rv.first.organization == @organization &&
                                          nil == Report.find_by_id(rv.first.id)}
    respond_with(@organization, @versions)
  end

  def undelete
    version = params[:version_id]
    rep = Version.find(version).reify
    rep.save
    respond_with(@organization, @report = @organization.reports.find(rep.id))
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
