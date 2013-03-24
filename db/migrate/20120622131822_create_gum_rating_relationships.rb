class CreateGumRatingRelationships < ActiveRecord::Migration
  def change
    create_table :gum_rating_relationships do |t|
      t.references :profile
      t.references :gum
      t.integer "rank_1"
      t.integer "rank_2"
      t.integer "rank_3"
      t.integer "rank_4"
      t.integer "rank_5"
      t.text "comment"
      t.float "average" #was integer
      t.integer "total"
      t.timestamps
    end
    add_index :gum_rating_relationships, ['profile_id', 'gum_id']
  end
end
