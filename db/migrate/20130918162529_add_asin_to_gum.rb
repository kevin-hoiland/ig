class AddAsinToGum < ActiveRecord::Migration
  def change
    add_column :gums, :asin, :string
  end
end
