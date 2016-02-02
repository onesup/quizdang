class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :question_type, null: false
      t.string :text, null: false
      t.integer :status, default: 0, null: false
      t.integer :views_count, default: 1, null: false
      t.references :quiz, index: true, foreign_key: true
      t.references :photo, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :subdang, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
