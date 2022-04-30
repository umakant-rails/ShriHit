class AddUserIdToArticleTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :article_types, :user_id, :integer
  end
end
