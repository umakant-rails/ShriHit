class CreateStrotaArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :strota_articles do |t|

      t.timestamps
    end
  end
end
