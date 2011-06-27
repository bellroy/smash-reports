class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string "name",        :allow_null => false
      t.text   "description", :default => "", :allow_null => false
      t.text   "sql_query",   :allow_null => false
      t.text   "defaults",    :default => "", :allow_null => false

      t.timestamps
    end
  end
end
