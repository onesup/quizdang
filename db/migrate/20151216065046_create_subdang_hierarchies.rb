class CreateSubdangHierarchies < ActiveRecord::Migration
  def change
    create_table :subdang_hierarchies, id: false do |t|
      t.integer :ancestor_id, null: false
      t.integer :descendant_id, null: false
      t.integer :generations, null: false
    end

    add_index :subdang_hierarchies, [:ancestor_id, :descendant_id, :generations],
      unique: true,
      name: "subdang_anc_desc_idx"

    add_index :subdang_hierarchies, [:descendant_id],
      name: "subdang_desc_idx"
  end
end
