module ReportsHelper
  def reports_url(*args)
    organization_reports_url(@organization, *args)
  end

  def new_report_url(*args)
    new_organization_report_url(@organization, *args)
  end

  def report_url(report, *args)
    organization_report_url(report.organization, report, *args)
  end

  def edit_report_url(report, *args)
    edit_organization_report_url(report.organization, report, *args)
  end

  def delete_report_url(report, *args)
    organization_report_url(report.organization, report, *args)
  end

  def revert_report_url(report, *args)
    revert_organization_report_url(report.organization, report, *args)
  end

  def url_for(*args)
    return report_url(args.first) if args.first && args.first.is_a?(Report)
    super
  end
end
