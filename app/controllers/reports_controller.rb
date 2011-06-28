class ReportsController < ApplicationController
  respond_to :html
  respond_to :csv, :only => :show

  def index
    respond_with(@reports = Report.all)
  end

  def show
    @report = Report.find(params[:id])
    @report.field_values = params[:field_values]
    @report.execute
    respond_with @report do |format|
      format.csv { render :text => @report.to_csv }
    end
  end

  def new
    respond_with(@report = Report.new)
  end

  def edit
    respond_with(@report = Report.find(params[:id]))
  end

  def create
    respond_with(@report = Report.create(params[:report]))
  end

  def update
    respond_with(@report = Report.update(params[:id], params[:report]))
  end

  def destroy
    @report = Report.destroy(params[:id])
    respond_with(@report, :location => reports_url)
  end
end
