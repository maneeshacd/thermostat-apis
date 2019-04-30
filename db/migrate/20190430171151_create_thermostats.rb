class CreateThermostats < ActiveRecord::Migration[5.2]
  def change
    create_table :thermostats do |t|
      t.string :household_token, null: false
      t.text :address, null: false
      t.timestamps
    end
    add_index :thermostats, %i[household_token]
  end
end
