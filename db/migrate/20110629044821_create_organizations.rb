class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :long_name
      t.string :name

      t.timestamps
    end

    add_index :organizations, :name, :unique => true

    create_table :organizations_users, :id => false do |t|
      t.integer :organization_id
      t.integer :user_id
    end

    Report.destroy_all
    add_column :reports, :organization_id, :integer, :allow_null => false
  end
end
