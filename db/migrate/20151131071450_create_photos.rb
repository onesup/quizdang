class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :image
      t.string :unique_id, null: false
      t.string :source

      t.timestamps null: false
    end

    add_index :photos, :unique_id, unique: true
  end
end
