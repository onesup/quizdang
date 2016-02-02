class CreateBadgings < ActiveRecord::Migration
  def change
    create_table :badgings do |t|
      t.references :badge, index: true, foreign_key: true
      t.references :badgeable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
