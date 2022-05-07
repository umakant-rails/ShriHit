class CreateThemeChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :theme_chapters do |t|
      t.string  :name
      t.integer :user_id
      t.integer :theme_id

      t.timestamps
    end
  end
end
