class AddHashtaggingsIndex < ActiveRecord::Migration
  def change
    add_index :hashtaggings, [:hashtag_id, :hashtaggable_id, :hashtaggable_type], name: "index_hashtaggings_on_hashtag_hashtaggable", unique: true
  end
end
