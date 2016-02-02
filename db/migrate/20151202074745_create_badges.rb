class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.string :slug, null: false
      t.integer :kind, null: false
      t.integer :level, null: false
      t.boolean :active, default: false, null: false

      t.timestamps null: false
    end
  end
end
