class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.boolean :correct
      t.references :question, index: true, foreign_key: true
      t.references :option, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
