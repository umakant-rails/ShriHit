class CreateThemes < ActiveRecord::Migration[7.0]
  def change
    create_table :themes do |t|
      t.string :name
      t.integer :is_approved
      t.integer :user_id
      t.timestamps
    end
  end
end
