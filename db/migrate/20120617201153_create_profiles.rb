class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.integer "subscriptions_created", :default => 0, :null => false
      t.integer "subscriptions_deleted", :default => 0, :null => false
      t.string "name"
      t.string "location"
      t.string "age"
      t.string "sex"
      t.text "story"
      t.timestamps
    end
    add_index :profiles, ['user_id']
  end
end
