class AddNameUsernameAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :username, :string, null: false, default: ""
    add_column :users, :avatar, :string

    add_index :users, :username, unique: true
  end
end
