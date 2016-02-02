class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.text :details, null: false
      t.string :email_address, null: false

      t.timestamps null: false
    end
  end
end
