class CreateScriptures < ActiveRecord::Migration[7.0]
  def change
    create_table :scriptures do |t|
      t.integer   :scripture_type_id
      t.string    :name
      t.string    :name_eng
      t.text      :description
      t.integer   :author_id
      t.string    :size
      t.boolean   :has_section, default: false
      t.boolean   :has_chapter, default: false
      t.timestamps
    end
  end
end
