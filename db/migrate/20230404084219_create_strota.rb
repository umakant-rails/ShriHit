class CreateStrota < ActiveRecord::Migration[7.0]
  def change
    create_table :strota do |t|
      t.string :name
      t.text :source
      t.integer :strota_type_id
      t.string :keyword

      t.timestamps
    end
  end
end
