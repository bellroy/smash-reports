require 'organization_manager'

namespace :organizations do
  desc "Create a new organization" do
    task :create => :environment do
      OrganizationManager.new.create_org
    end

    task :delete => :environment do
      OrganizationManager.new.delete_org
    end

    task :list => :environment do
      OrganizationManager.new.list_orgs
    end
  end
end
