class CreateSubdangs < ActiveRecord::Migration
  def change
    create_table :subdangs do |t|
      t.string :name, null: false
      t.string :featured_image
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :subdangs, :name, unique: true
  end
end
