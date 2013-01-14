class CreateGumRatingRelationships < ActiveRecord::Migration
  def change
    create_table :gum_rating_relationships do |t|
      t.references :profile
      t.references :gum
      t.integer "gumtation"
      t.integer "initial_gumalicious"
      t.integer "overall_gumalicious"
      t.integer "gumalicious_gumgevity"
      t.integer "flavoracity"
      t.integer "initial_chewlasticity"
      t.integer "overall_chewlasticity"
      t.integer "chewlasticity_gumgevity"
      t.integer "bubbability"
      t.integer "breathalation"
      t.text "comment"
      t.float "average" #was integer
      t.integer "total"
      t.timestamps
    end
    add_index :gum_rating_relationships, ['profile_id', 'gum_id']
  end
end
