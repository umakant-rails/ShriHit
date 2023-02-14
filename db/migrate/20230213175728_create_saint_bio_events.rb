class CreateSaintBioEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :saint_bio_events do |t|
      t.string :title
      t.text :event
      t.integer :user_id
      t.integer :author_id

      t.timestamps
    end
  end
end
