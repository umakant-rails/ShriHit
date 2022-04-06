class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.text :content
      t.integer :writer_id
      t.integer :user_id
      t.integer :article_type_id
      t.integer :theme_id
      t.integer :context_id
      t.string  :hindi_title
      t.string  :english_title
      t.timestamps
    end
  end
end
