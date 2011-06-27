class ReportsController < ApplicationController
  respond_to :html

  def index
    respond_with(@reports = Report.all)
  end

  def show
    respond_with(@report = Report.find(params[:id]))
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
