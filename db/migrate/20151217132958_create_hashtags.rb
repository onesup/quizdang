class CreateHashtags < ActiveRecord::Migration
  def change
    create_table :hashtags do |t|
      t.string :name, null: false
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :hashtags, :name, unique: true
  end
end
