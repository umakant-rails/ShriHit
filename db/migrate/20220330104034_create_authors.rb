class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name
      t.string :sampradaya_id
      t.text :biography
      t.date :birth_date
      t.date :death_date
      t.integer :is_approved
      t.integer :user_id
      
      t.timestamps
    end
  end
end
