require 'user_manager'

namespace :users do
  desc "Create a new user"
  task :create => :environment do
    UserManager.new.create_user
  end

  desc "Delete a user"
  task :delete => :environment do
    UserManager.new.delete_user
  end

  desc "List users"
  task :list => :environment do
    UserManager.new.list_users
  end

  desc "Change a user's organization membership"
  task :select_orgs => :environment do
    UserManager.new.select_orgs
  end
end
