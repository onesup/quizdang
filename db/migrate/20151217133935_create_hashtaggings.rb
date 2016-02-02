class CreateHashtaggings < ActiveRecord::Migration
  def change
    create_table :hashtaggings do |t|
      t.references :hashtag, index: true, foreign_key: true
      t.references :hashtaggable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
