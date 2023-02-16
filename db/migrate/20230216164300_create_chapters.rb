class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.integer   :section_id
      t.string    :title
      
      t.timestamps
    end
  end
end
