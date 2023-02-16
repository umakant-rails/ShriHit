class CreateScriptures < ActiveRecord::Migration[7.0]
  def change
    create_table :scriptures do |t|
      t.integer   :scripture_type_id
      t.string    :name
      t.text      :description
      t.string    :author
      t.string    :size
      t.boolean   :has_chapter, default: false

      t.timestamps
    end
  end
end
