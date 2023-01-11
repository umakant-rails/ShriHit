class CreateCalendars < ActiveRecord::Migration[7.0]
  def change
    create_table :calendars do |t|
      t.date :date
      t.string :panchang_tithi
      t.string :panchang_month
      t.string :paksh
      t.text :description
      t.string :panchange_type
      t.integer :vikram_samvat
      t.integer :year
      t.timestamps
    end
  end
end
