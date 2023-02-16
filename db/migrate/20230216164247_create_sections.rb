class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.integer :scripture_id
      t.string :title
      t.text   :description
      
      t.timestamps
    end
  end
end
