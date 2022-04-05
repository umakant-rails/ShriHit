class CreateWriters < ActiveRecord::Migration[7.0]
  def change
    create_table :writers do |t|
      t.string :name
      t.string :sampraday
      t.text :biography
      t.date :birth_date
      t.date :death_date

      t.timestamps
    end
  end
end
