class AddParentIdToSubdangs < ActiveRecord::Migration
  def change
    add_column :subdangs, :parent_id, :integer
  end
end
