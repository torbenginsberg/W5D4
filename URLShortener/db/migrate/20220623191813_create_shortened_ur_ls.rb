class CreateShortenedUrLs < ActiveRecord::Migration[6.1]
  def change
    create_table :shortened_ur_ls do |t|
      t.string :long_url, null: false
      t.string :short_url, null: false
      t.integer :user_id, null: false
      t.timestamps
    end

    add_index :shortened_ur_ls, :short_url, unique: true
    add_index :shortened_ur_ls, :user_id, unique: true
  end
end
