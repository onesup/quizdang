class AddParentIdToHashtags < ActiveRecord::Migration
  def change
    add_column :hashtags, :parent_id, :integer
  end
end
