class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :fb_id
      t.text :fb_json

      t.timestamps
    end

    add_index :posts, :fb_id
  end
end
