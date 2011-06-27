config = ActiveRecord::Base.configurations[Rails.env].symbolize_keys
DB = Sequel.connect(config)
