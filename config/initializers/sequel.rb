REPORT_DBS = {}
configs = YAML.load_file File.join(Rails.root, 'config/database-reports.yml')

configs.each do |key, options|
  db = Sequel.connect(options.symbolize_keys)
  REPORT_DBS[key.to_s] = db
end

