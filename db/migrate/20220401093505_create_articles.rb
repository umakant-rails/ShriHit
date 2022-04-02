class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :content
      t.string :writer
      t.integer :user_id
      t.integer :article_type_id
      t.integer :event_id

      t.timestamps
    end
  end
end
