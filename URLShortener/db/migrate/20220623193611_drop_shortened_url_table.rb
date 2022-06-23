class DropShortenedUrlTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :shortened_ur_ls
  end
end
