class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.string :text, null: false
      t.boolean :correct, null: false, default: false
      t.references :question, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
