config = ActiveRecord::Base.configurations["#{Rails.env}-reports"].symbolize_keys
DB = Sequel.connect(config)
