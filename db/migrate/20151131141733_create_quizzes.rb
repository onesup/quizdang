class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.text :description
      t.string :featured_image
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
